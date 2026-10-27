# Adding a sanity check

Part of the dltemplates project `CLAUDE.md`, loaded on demand: clone dltemplates into a scratch directory and read this file only when the task calls for it.


When a student asks for a "sanity check" (or similar — a first-look diagnostic on their
pipeline output), this means a specific deliverable: an NMDS ordination plus a stacked
phylum-level taxonomy composition barplot, as a new `sanity_check.qmd`. Prerequisites:
pipeline output already fetched into `data/` as Parquet files (see `fetch-pipeline-output.md`, including a sample
table if one exists — needed to colour/shape the NMDS).
If `data/` has only TSVs, go back to step 5 of the fetching instructions and offer to
convert them first; the templates read Parquet only.

1. `git clone --depth 1 https://github.com/erikrikarddaniel/dltemplates <tmpdir>` into a
   scratch/temp directory, same as the initial project bootstrap — never inside the
   project directory, and delete it once done.
2. Copy `<tmpdir>/R/sanity_check_<pipeline>.qmd` to `sanity_check.qmd` in the project root
   (`<pipeline>` is `ampliseq`, `magmap`, or `metatdenovo`, matching whichever pipeline
   step 1 of `fetch-pipeline-output.md` already established), and
   `<tmpdir>/R/sanity_check_core.R` to `scripts/sanity_check_core.R` — the qmd `source()`s
   it for the shared statistics/palette-consistency logic. Unlike `convert_to_parquet.R`,
   this isn't part of the default scaffold, so it only exists in a project once a sanity
   check has actually been added.
3. Fill in the templated bits: the `__TITLE__` placeholder in the YAML header, and, for
   `metatdenovo` specifically, the `PREFIX` constant (`__ASSEMBLY_ORFCALLER__`) in the
   `constants` chunk — set it to match whichever `<assembly>.<orfcaller>` prefix is
   actually on the files in `data/` (`Sys.glob("data/*.counts.parquet")` shows what's
   there if it's not obvious from context).
4. The `read-data` chunk in each template has pipeline-specific notes worth rereading
   before trusting it blindly — in particular, `ampliseq`'s choice of taxonomy table (the
   consolidated DADA2 table if present, otherwise the first DADA2 one; with several
   databases the student may want a different one) and, for runs before 3.0, its comment
   about verifying `ASV_table.tsv`'s header format, and `metatdenovo`'s about which taxonomy source
   (EUKulele vs. Diamond) is actually present in this project's `data/`.
5. These templates need `RColorBrewer`, `vegan`, `patchwork` (`metatdenovo`'s also
   combines two NMDS panels with `patchwork::plot_layout(guides = "collect")`),
   `duckplyr` and `ecolongr` — ask before installing whichever the student doesn't
   already have.
   `ecolongr` is not on CRAN and needs a C++ compiler:
   `remotes::install_github("biodiversitydata-se/ecolongr")` (install `remotes` first if
   it is missing).
   Version 0.1.1 or later is required, because 0.1.0 gives wrong, run-dependent distances when `el_vegdist()` runs on several threads.
   Check with `packageVersion("ecolongr")` and reinstall if it is older.
   The NMDS chunks use `ecolongr::el_vegdist()` to compute Bray-Curtis distances straight
   from the long table, without building the samples-by-taxa matrix `vegan` would need,
   and pass the result to `vegan::metaMDS()`.
   The `ampliseq` template reads the 3.0 `ampliseq.counts.parquet` and
   `ampliseq.taxonomy.DADA2.*.parquet` when they exist.
   For older runs it falls back to unpivoting the wide `ASV_table.parquet` to a long table
   inside DuckDB.
6. Once it's built and rendering, ask the student whether you should walk them through the
   code and how it's set up (the `sanity_check_core.R` functions, the loader, why NMDS
   uses no transformation, the palette-consistency mechanism, etc.) — don't launch into an
   unprompted explanation, but do offer, since this is exactly the kind of code a student
   is expected to understand and eventually extend themselves, not just run.

The taxonomy barplot's non-top taxa always split into two separate stacked categories,
`Other` and `Unassigned`, rather than one combined bucket — `taxonomy_barplot_data()` in
`sanity_check_core.R` does this automatically, no per-project wiring needed.
`Unassigned` is features (ASVs/ORFs) with no classification at all at that rank (`NA`) — a
statement about classification coverage/reference-database recall.
`Other` is features that *are* classified, just individually below `threshold` — a
statement about true community diversity (many genuine low-abundance taxa).
Conflating the two into one "Other" bucket (an earlier version of this function did) hides
which of those two very different explanations actually dominates a sample, which matters
for a sanity check specifically: a mostly-`Unassigned` bar points at a reference-database
or classification-pipeline problem worth investigating, while a mostly-`Other` bar just
reflects a genuinely diverse community and is often unremarkable.
Confirmed worth the split on real data (remedios_non-polyA_overview, metatdenovo,
2026-09-10): the combined bucket ran 50-70% of TPM per sample, opaque as to why; keep an
eye out for the same pattern recurring on other real runs once this has been used a few
more times.

