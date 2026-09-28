# sanity_check_core.R
#
# Shared statistics/data-prep functions for the "sanity check" NMDS + taxonomy composition
# analysis (see project_template/CLAUDE.md). Meant to be `source()`d from sanity_check.qmd,
# not run standalone. Pipeline-specific loader code (turning raw pipeline output into the
# common `sample` / <rank> / <value> tidy shape these functions expect) lives in the qmd
# itself, not here -- this file only knows about that common shape.
#
# Deliberately stops short of the actual ggplot() calls: those stay as verbatim chunks in
# the qmd, since that's the part worth a student seeing and tweaking. This file only holds
# the fiddly, easy-to-get-subtly-wrong parts (rank aggregation, Other-folding, palette
# consistency) that are worth getting right once rather than rewriting per project.
#
# To keep the same taxon getting the same colour in every plot in a document, build a
# palette once with assign_palette() and reuse it in every plot that uses that variable,
# rather than building a fresh one per plot.

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(RColorBrewer))

# Per-taxon sum/mean/max of `value` across samples, at whatever grouping `rank` is (e.g.
# family, phylum, ko). Two-pass: samples are collapsed to per-(rank, sample) totals first,
# so mean/max reflect variation *across samples* for that taxon, not across the individual
# features (ASVs/ORFs) that happen to make it up.
rank_stats <- function(tbl, rank, value) {
  tbl %>%
    group_by({{ rank }}, sample) %>%
    summarise(.persample = sum({{ value }}, na.rm = TRUE), .groups = "drop_last") %>%
    summarise(sum = sum(.persample), mean = mean(.persample), max = max(.persample), .groups = "drop")
}

# Taxa clearing `threshold` on `stat`, sorted descending (so callers can use this order
# directly as plot/legend order). For `stat = "sum"`, threshold is a proportion of the
# grand total (portable across datasets with different sample counts). For "mean"/"max",
# threshold applies directly to that column, since a per-sample total of a relative measure
# (TPM, relative abundance) is already comparable across datasets without renormalizing.
top_taxa <- function(tbl, rank, value, stat = c("sum", "mean", "max"), threshold = 0.01) {
  stat <- match.arg(stat)
  stats <- rank_stats(tbl, {{ rank }}, {{ value }})
  # Score before dropping undefined/NA taxa, so a "sum" threshold is still a proportion of
  # the true (pre-removal) total -- but NA itself never comes back as a *named* top taxon,
  # it always ends up folded into `other` downstream.
  stats$score <- if (stat == "sum") stats$sum / sum(stats$sum) else stats[[stat]]
  stats <- stats[!is.na(stats[[1]]), ]
  stats <- arrange(stats, desc(score))
  pull(filter(stats, score >= threshold), 1)
}

# Registry of which palette is already claimed by which variable in the current render, so
# reusing e.g. "Paired" for two different things (phylum and treatment, say) gets flagged
# rather than silently producing two plots where the same colour means different things.
.palette_registry <- new.env(parent = emptyenv())

# Named vector mapping each of `taxa` (in the order given -- pass top_taxa()'s output
# directly to keep plot/legend order) to a colour, plus `other` to `other_colour` and
# `unassigned` to `unassigned_colour`. Falls back to the Polychrome package for >12 taxa,
# since Brewer palettes top out at 12 genuinely distinguishable colours; if Polychrome
# isn't installed, warns and repeats Brewer colours instead of failing outright.
#
# The `other`/`unassigned` pair is only meaningful for a taxonomy_barplot_data() palette
# (see below) -- calling this for a non-taxonomic variable (e.g. a `station` NMDS colour)
# just carries two unused named entries, harmless since scale_*_manual() only draws a
# legend for levels actually present in the data being plotted.
assign_palette <- function(taxa, variable, palette = "Paired", other = "Other", other_colour = "grey70",
                            unassigned = "Unassigned", unassigned_colour = "grey40") {
  n <- length(taxa)

  claimed_by <- .palette_registry[[palette]]
  if (!is.null(claimed_by) && !identical(claimed_by, variable)) {
    warning(sprintf(
      "Palette '%s' is already used for '%s' in this document -- reusing it for '%s' will make them indistinguishable. Pick a different palette.",
      palette, claimed_by, variable
    ), call. = FALSE)
  }
  .palette_registry[[palette]] <- variable

  colours <- if (n <= 12) {
    brewer.pal(max(n, 3), palette)[seq_len(n)]
  } else if (requireNamespace("Polychrome", quietly = TRUE)) {
    unname(Polychrome::palette36.colors(n))
  } else {
    warning(sprintf(
      "%d taxa exceeds Brewer's 12-colour limit for '%s'; install the Polychrome package for a properly distinguishable palette (colours will repeat below).",
      n, palette
    ), call. = FALSE)
    rep_len(brewer.pal(12, palette), n)
  }

  setNames(c(colours, other_colour, unassigned_colour), c(taxa, other, unassigned))
}

# Aggregated, ggplot-ready table for a stacked taxonomy barplot: one row per (sample,
# taxon-or-`other`-or-`unassigned`), `.display` a factor ordered to match `top` (typically
# top_taxa()'s output) so a manually-built palette keyed the same way lines up directly.
# Taxa not in `top` split into two buckets, kept separate rather than folded into one
# "Other" as earlier versions of this function did -- they answer different questions
# about the data, and conflating them hides which one actually dominates:
#   - `unassigned`: `rank` is NA, i.e. the feature (ASV/ORF) was never classified at this
#     rank at all -- a statement about classification coverage/reference-database recall.
#   - `other`: `rank` is a real, classified value, just below `threshold` -- a statement
#     about true community diversity/evenness (many genuine low-abundance taxa).
# `value` is never renormalized after this split, so each bucket's share in the resulting
# table reflects its true proportion of the original data, not just of what's plotted.
#
# Typical use in the qmd -- top/palette built once and reused, the ggplot() call itself
# left as a verbatim chunk rather than wrapped in a function:
#
#   top <- top_taxa(tbl, phylum, tpm, threshold = 0.01)
#   pal <- assign_palette(top, variable = "phylum")
#   plot_tbl <- taxonomy_barplot_data(tbl, phylum, tpm, top)
#
#   ggplot(plot_tbl, aes(x = sample, y = value, fill = .display)) +
#     geom_col() +
#     scale_fill_manual(values = pal, name = "Phylum") +
#     labs(x = NULL, y = NULL) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
taxonomy_barplot_data <- function(tbl, rank, value, top, other = "Other", unassigned = "Unassigned") {
  tbl %>%
    mutate(.display = case_when(
      is.na({{ rank }}) ~ unassigned,
      {{ rank }} %in% top ~ as.character({{ rank }}),
      TRUE ~ other
    )) %>%
    group_by(sample, .display) %>%
    summarise(value = sum({{ value }}, na.rm = TRUE), .groups = "drop") %>%
    mutate(.display = factor(.display, levels = c(top, other, unassigned)))
}

# vim: sw=2
