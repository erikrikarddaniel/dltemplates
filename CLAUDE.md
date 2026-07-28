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
- `setup_project.sh` — scaffolds a new analysis project directory: creates `data/`,
  `scripts/`, `figures/` (with a `.gitignore` for generated images), a `Makefile` and
  `data/Makefile`, copies in `project.Rproj`, `misc/gitignore`, and `misc/tools.bib`,
  renders `misc/screenrc` (substituting `__PROJNAME__` and splicing in `data`/`scripts`
  screen windows at `__INSERTPOINT__`), copies `R/quarto.qmd` to `<projectname>.qmd`,
  touches an empty `bibliography.bib`, and runs `git init` + `git add .`. Usage:
  `./setup_project.sh <project_name>` (run from within the intended parent directory —
  it `mkdir`s and `cd`s into `<project_name>` relative to the current directory).

## Working in this repo

- Changes are almost always edits to a single template file; there's no cross-file
  dependency graph to reason about beyond `setup_project.sh`'s references to
  `R/project.Rproj`, `misc/screenrc`, `misc/gitignore`, `misc/tools.bib`, and
  `R/quarto.qmd`, so if you rename or move any of those, update `setup_project.sh` too.
  Same for `misc/tools.bib` / `bibliography.bib` / `grateful-refs.bib` being referenced by
  filename in every R Markdown/Quarto template's YAML front matter.
- Keep the `__PLACEHOLDER__` naming convention consistent when adding new templates —
  it's the pattern `setup_project.sh` and users' own `sed` substitutions rely on.
- There's no automated test suite; verify changes to `setup_project.sh` by actually running
  it against a scratch directory.
