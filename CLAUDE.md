# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A personal grab-bag of skeleton/template files for starting new scripts, analyses, and jobs
(R, Ruby, Quarto/R Markdown, Slurm, Makefiles, screen sessions). There is no build, test, or
lint tooling — files here are copied into other projects and filled in, not executed in place.
Most files are named or contain `__PLACEHOLDER__`-style tokens (e.g. `__TITLE__`,
`__AUTHOR_EMAIL__`, `__SCRIPT_NAME__`, `__PROGRAM__`) meant to be replaced by hand or via
`sed` when a template is instantiated into a new project.

## Layout

- `R/` — R script and R Markdown/Quarto templates.
  - `rsimple.r` — minimal script skeleton with common tidyverse/data.table imports.
  - `rformats.r` — script skeleton with `optparse` CLI parsing, a `logmsg()` logger, and
    an `--formats`/multi-format-output convention.
  - `prepare_data.R` — minimal data-loading script skeleton (imports only).
  - `quarto.qmd`, `rmarkdown.Rmd`, `rbookdown.Rmd`, `rmarkdown_ggtree.Rmd`,
    `rmarkdown_with_sqlite.rmd`, `presentation.qmd` — report/notebook templates for different
    output targets, all following the same section skeleton (Version history, Summary,
    Introduction, Materials and Methods, Results, Discussion, References) and citing
    packages via `grateful::cite_packages()` plus a shared `bibliography.bib` +
    `tools.bib` + `grateful-refs.bib` bibliography set.
  - `project.Rproj` — RStudio project file (`BuildType: Makefile`), copied into new projects
    by `setup_project.sh`.
  - `convert_to_parquet.R` — generic one-file-in/one-file-out TSV(.gz)-to-Parquet converter
    (two positional args: infile, outfile), meant to be called once per table from a
    `data/Makefile` pattern rule. Copied into every scaffolded project's `scripts/` by
    `setup_project.sh`, for pipeline output whose version/flags didn't already produce
    Parquet — see `project_template/CLAUDE.md`'s "Fetching pipeline output into `data/`".
  - `sanity_check_core.R` — shared `rank_stats()`/`top_taxa()`/`assign_palette()`/
    `taxonomy_barplot_data()` functions for the NMDS + taxonomy composition "sanity check"
    analysis (see project_template/CLAUDE.md's own doc comment at the top of the file for
    what each does and why, and its cross-plot palette-consistency registry). Deliberately
    stops short of the actual `ggplot()` calls — those are meant to stay as verbatim,
    readable chunks in whichever `sanity_check_<pipeline>.qmd` copies it in, not hidden
    behind a plotting function. Not part of the default scaffold (unlike
    `convert_to_parquet.R`); copied into a project's `scripts/` only when a sanity check is
    actually being added.
  - `sanity_check_ampliseq.qmd`, `sanity_check_magmap.qmd`, `sanity_check_metatdenovo.qmd` —
    one "sanity check" report template per pipeline (NMDS + phylum-level composition
    barplot; `metatdenovo`'s also has a second, functional NMDS from KOfamScan's
    best-hit-per-ORF table, combined with the taxonomic one via `patchwork`). Each contains
    a `read-data` chunk with that pipeline's specific file/column layout (verified against
    each pipeline's actual source as of 2026-09 — `ampliseq` pre-3.0 has no direct relative
    abundance, computed here from ASV counts instead) and sources `sanity_check_core.R` for
    the shared stats/palette logic. Same section skeleton and bibliography set as the other
    report templates above.
- `ruby/` — Ruby CLI script skeletons using `optparse`, one plain and one
  (`ruby_w_output_format_template`) with a pluggable `FORMATS` dispatch table for
  multiple output formats.
- `slurm/slurm_skeleton.sbatch` — Slurm batch job skeleton (`__NUM_HOURS__`, `__JOBNAME__`,
  `__PARTITION__`, `__EMAIL_ADDRESS__`, `__CALL__` placeholders).
- `misc/`
  - `bash_script.sh` — minimal bash script header skeleton.
  - `makefile.library` — a `make`-include template for wrapping a bioinformatics tool as a
    Makefile pattern rule; it writes a `.makecall` companion file recording the tool version,
    parameters, and input files/timestamps for provenance, alongside each output file.
  - `gitignore` — a project-root `.gitignore` template tuned for bioinformatics repos (avoids
    committing large sequence/alignment data: `*.fastq*`, `*.fna`, `*.gz`, `*.dmnd`, etc.).
  - `screenrc` — GNU screen session template with an `__INSERTPOINT__` marker line that
    `setup_project.sh` uses to splice in extra per-project `screen -t` windows.
  - `tools.bib` — shared BibTeX library of tool/database citations (used by the R
    Markdown/Quarto report templates above).
- `.screenrc` — this repo's own screen session layout (windows for `R`, `ruby`, `slurm`,
  `claude`, `man`, `root`), separate from the `misc/screenrc` template.
- `project_template/CLAUDE.md` — the single-file bootstrap for a **new** project. It's meant
  to be copied alone into a bare/empty directory; starting a Claude Code session there and
  asking it to set things up makes Claude `git clone --depth 1` this repo into a scratch temp
  dir, run that clone's `setup_project.sh` with no argument to build the full scaffold in
  place, then delete the temp clone. `setup_project.sh` also copies this file into every
  project it scaffolds, so it doubles as that project's ongoing documentation afterward
  (structure, GitHub remote setup, etc.) — distinct from this repo's own root `CLAUDE.md`
  (this file), which documents *this* template repo for whoever edits templates here.
- `setup_project.sh` — scaffolds a standard project directory, in one of three modes: given
  a dirname that doesn't exist yet, creates and `cd`s into it; given a dirname that already
  exists, sets up inside it as-is (e.g. a student who already created the directory); given
  no argument, sets up the current directory in place, using its basename as the project
  name. In every mode it creates `data/`, `scripts/` (pre-populated with
  `convert_to_parquet.R`), `figures/` (with a `.gitignore` for generated images), and
  `docs/`, a `Makefile` and `data/Makefile`, copies in `project.Rproj`,
  `project_template/CLAUDE.md`, `misc/gitignore`, and `misc/tools.bib`, renders
  `misc/screenrc` (substituting `__PROJNAME__` and splicing in `data`/`scripts`/`docs`
  screen windows at `__INSERTPOINT__`), copies `R/quarto.qmd` to `<projectname>.qmd`, touches
  an empty `bibliography.bib`, and runs `git init` + `git add .`. Usage:
  `./setup_project.sh [project_name]`.

## Working in this repo

- Changes are almost always edits to a single template file; there's no cross-file
  dependency graph to reason about beyond `setup_project.sh`'s references to
  `R/project.Rproj`, `R/convert_to_parquet.R`, `project_template/CLAUDE.md`,
  `misc/screenrc`, `misc/gitignore`, `misc/tools.bib`, and `R/quarto.qmd`, so if you rename
  or move any of those, update `setup_project.sh` too. Same for `misc/tools.bib` /
  `bibliography.bib` / `grateful-refs.bib` being referenced by filename in every R
  Markdown/Quarto template's YAML front matter.
- `project_template/CLAUDE.md` describes `setup_project.sh`'s behavior (structure created,
  usage modes) in its own words for the benefit of a scaffolded project's users. If you
  change what `setup_project.sh` creates or how it's invoked, update both this file and
  `project_template/CLAUDE.md` to match — they drifted out of sync before (see git history:
  "sync setup_project.sh with CLAUDE.md").
- Keep the `__PLACEHOLDER__` naming convention consistent when adding new templates —
  it's the pattern `setup_project.sh` and users' own `sed` substitutions rely on.
- There's no automated test suite; verify changes to `setup_project.sh` by actually running
  it against a scratch directory.
