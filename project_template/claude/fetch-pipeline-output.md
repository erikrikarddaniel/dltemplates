# Fetching pipeline output into data/

Part of the dltemplates project `CLAUDE.md`, loaded on demand: clone dltemplates into a scratch directory and read this file only when the task calls for it.


The raw material for these projects is normally the output of an nf-core annotation
pipeline — `ampliseq`, `metatdenovo`, or `magmap` — run elsewhere, usually on an HPC
cluster, never inside this repo. That output is far too large to commit, so it's fetched
into `data/` on demand via `data/Makefile`, which RStudio's Build pane already runs (via
`project.Rproj`'s `BuildType: Makefile` and the root `Makefile`'s `cd data; make all`).

When a student wants this wired up and it isn't yet (`data/Makefile` still just says
`all:`), help them fill it in:

1. Ask which pipeline produced the data, if not already clear, for the absolute path to
   that run's output directory (`<outdir>`, conventionally named `results`), and whether
   that path is on **this same machine** or a **remote** one (e.g. an HPC cluster) — this
   decides the fetch mechanism in step 3 below. Also ask whether they have a sample table
   (treatment, site, time of year, or whatever else distinguishes their samples) — none of
   these pipelines produce one themselves, but it's needed to colour/shape the NMDS plot in
   the sanity check (see `sanity-check.md`). If they have one, copy it to `data/sample_table.tsv`.
2. Only a subset of files in each source directory actually matters, so filter rather
   than fetching everything — which files depends on the pipeline:
   - `ampliseq` 3.0 and later (released 2026-10-09) → the `ampliseq.*` files in
     `<outdir>/summary_tables`: `ampliseq.counts.*` (long table: `asv_id`, `sample`,
     `count`) and `ampliseq.taxonomy.<CLASSIFIER>.<database>.*` (one per classifier and
     database; lower-case rank columns).
     Look for them first: `ls <outdir>/summary_tables/ampliseq.counts.*`.
     The counts table is only written with `--asv_calling dada2`.
   - `ampliseq` before 3.0, or without `summary_tables/ampliseq.counts.*` → the `*.tsv`
     files in `<outdir>/dada2`
   - `metatdenovo` or `magmap` → the `*.tsv.gz` files in `<outdir>/summary_tables`
   - all three, in addition → `<outdir>/pipeline_info/*versions*.yml`.
     Don't narrow this to `*software_versions*.yml`.
     The exact filename order isn't consistent across pipelines — confirmed
     `nf_core_metatdenovo_software_mqc_versions.yml` on a real metatdenovo run
     (2026-09-10), where "mqc" sits between "software" and "versions" and a
     `*software_versions*` glob matches nothing.
     `*versions*.yml` matches that and any other ordering.
   Also look for Parquet copies of the summary tables alongside the TSVs, and use them if
   they exist.
   The analysis templates read Parquet (see "Working with Parquet tables in R" in the project `CLAUDE.md`),
   because it is faster to read and DuckDB loads only what a query needs.
   If there are none, offer to build them (step 5); don't build them without asking.
   Support is new and differs across these three pipelines (checked 2026-10), so
   don't assume from the pipeline name alone:
   - `magmap` (v1.2.0+, 2026-08-11): opt-in via `--save_parquet`; when used, every
     `summary_tables/*.tsv.gz` file gets a same-named `*.parquet` sibling.
   - `ampliseq` (3.0.0+, released 2026-10-09): every `summary_tables/ampliseq.*.tsv.gz`
     has a `.parquet` twin, on by default, opt-out via `--skip_parquet_summary`.
     Runs made with a version before 3.0 have neither.
   - `metatdenovo` (2.0.0+): opt-in via `--save_parquet`; when used, every
     `summary_tables/*.tsv.gz` file gets a same-named `*.parquet` sibling.
     Runs made with an older version, or without the flag, have none.
   The reliable check is the run's actual output directory, not the pipeline/version in
   the abstract: `ssh <alias> "ls <outdir>/summary_tables/*.parquet 2>/dev/null"`. If you can't check yet — e.g. the `ssh`
   alias isn't set up until step 3 below — ask the student whether they think there are
   Parquet files to fetch, and check again once the alias works.
3. Fetch via `rsync` over `ssh`, using an `ssh` config alias rather than a raw
   `user@host` — this is what makes the resulting `Makefile` reusable by teammates once
   it's committed and pushed. Each person defines the *same alias name* in their own
   `~/.ssh/config`, pointing at the same host but with their own username, so the alias
   itself must not have a username baked into it (don't call it e.g. `alice-cluster`; a
   short, cluster- or project-specific name works well, e.g. `anno`). Recommend a short
   alias name to the student and confirm they're happy with it — they'll type it in every
   fetch, and everyone else on the project will reuse the same name. Tell them where it's
   defined: their own `~/.ssh/config` (not part of this repo, and never committed — it's
   per-person, per-machine). If they don't already have an entry for this host, help them
   add one:
   ```
   Host anno
       HostName cluster.example.edu
       User their_remote_username
   ```
4. Write (or extend) `data/Makefile` with variables for the host alias and the remote
   `<outdir>` path, and one target per piece being fetched. In most cases it's simplest to
   land everything straight in `data/` itself rather than recreating the remote
   subdirectory structure locally — fetch each source into `.` (the recipes already run
   with `data/` as the working directory), not into a same-named subdirectory. Since these
   targets no longer produce a file/directory matching their own name, mark them
   `.PHONY` so `make` doesn't get confused about when to (re-)run them — harmless anyway,
   since `rsync` only re-transfers what changed. For an `ampliseq` project from before 3.0
   (3.0 and later use `summary_tables`, like `metatdenovo`/`magmap` below):
   ```makefile
   REMOTE_HOST   = anno
   REMOTE_OUTDIR = /path/to/the/run/results

   .PHONY: all dada2 pipeline_info

   all: dada2 pipeline_info

   dada2:
   	rsync -av --include='*.tsv' --exclude='*' $(REMOTE_HOST):$(REMOTE_OUTDIR)/dada2/ .

   pipeline_info:
   	rsync -av --include='*versions*.yml' --exclude='*' $(REMOTE_HOST):$(REMOTE_OUTDIR)/pipeline_info/ .
   ```
   For `metatdenovo`/`magmap`/`ampliseq` 3.0+, replace the `dada2` target with a
   `summary_tables` one that fetches `*.tsv.gz` from `$(REMOTE_OUTDIR)/summary_tables/` the same way (i.e.
   `--include='*.tsv.gz' --exclude='*'`). Keep the trailing slash on the remote (source)
   side of each `rsync` — without it, rsync nests the source directory inside the
   destination instead of copying its contents into it.
5. Wire in the Parquet files, one of two ways depending on what step 2 found:
   - **They already exist remotely**: add them to the same `rsync` target (or a sibling
     one) with `--include='*.parquet'`, and prefer reading the Parquet copies over the
     TSVs in the `.qmd` once fetched (the templates need only the Parquet files, so the
     `.tsv.gz` twins can be left out of the fetch) — same data, smaller and faster to load.
   - **They don't exist**: offer to build them after each download, and say why (the
     analysis templates read Parquet, which is faster and keeps the table out of R's
     memory).
     Wait for a yes before wiring anything in.
     If the student declines, the templates' `read-data` chunks must be rewritten to
     `read_tsv()`, which loads whole tables into memory; tell them that.
     On a yes: every project already has `scripts/convert_to_parquet.R`
     (scaffolded by `setup_project.sh`, no need to write it) — a generic one-file-in,
     one-file-out converter meant to be called once per table from a `data/Makefile`
     pattern rule. Two pattern rules are needed, one per source extension actually being
     fetched — `ampliseq`'s `dada2/*.tsv` is uncompressed, `metatdenovo`/`magmap`'s
     `summary_tables/*.tsv.gz` isn't, and a rule for one extension silently won't match
     the other:
     ```makefile
     %.parquet: %.tsv.gz
     	Rscript ../scripts/convert_to_parquet.R $< $@

     %.parquet: %.tsv
     	Rscript ../scripts/convert_to_parquet.R $< $@
     ```
     **A pattern rule alone does nothing** — `make` only applies a pattern rule to build a
     target something else actually asks for, so list every fetched table's `.parquet`
     filename by name, rather than reaching for `$(wildcard *.tsv.gz)`/`$(patsubst ...)` to
     generate that list automatically: `make` expands `$(wildcard ...)` once, when it first
     reads the Makefile — before the `dada2`/`summary_tables` recipe has fetched anything
     into a fresh `data/` — so it would see no `.tsv`/`.tsv.gz` files yet and silently
     produce an empty list.
     A hardcoded list is also more readable for someone new to `make`.

     **Do not list the `.parquet` files directly as prerequisites of `all`, even
     hardcoded — that still fails outright on a genuinely fresh `data/`.**
     Confirmed the hard way (metatdenovo output, 2026-09-10), on the very first `make all`
     run against an empty `data/`: GNU Make resolves a pattern rule's prerequisite (here,
     whether `foo.tsv.gz` exists, to satisfy `%.parquet: %.tsv.gz` for `foo.parquet`) via a
     `stat()` done once, the first time it considers that `.parquet` target while walking
     `all`'s prerequisite list — and that happens in the same left-to-right pass as `all`'s
     other prerequisites, before the fetch recipe that actually creates `foo.tsv.gz` has
     run.
     The result is a hard, deterministic error, not a silent no-op like the `$(wildcard
     ...)` case above:
     ```
     make: *** No rule to make target 'foo.parquet', needed by 'all'.  Stop.
     ```
     A second `make all` then succeeds, because by then the `.tsv.gz` files already exist
     from the first (partially-failed) run — easy to mistake for a one-off fluke rather
     than the reproducible GNU Make behavior it actually is.
     The fix: fetch first, then hand the Parquet conversions to a fresh sub-`make` — a new
     `make` process re-`stat()`s the filesystem from scratch, after the fetch recipes have
     already run:
     ```makefile
     .PHONY: all fetch parquet dada2 pipeline_info

     all: fetch
     	$(MAKE) parquet

     fetch: dada2 pipeline_info

     parquet: ASV_table.parquet ASV_tax.<database>.parquet

     dada2:
     	rsync -av --include='*.tsv' --exclude='*' $(REMOTE_HOST):$(REMOTE_OUTDIR)/dada2/ .

     pipeline_info:
     	rsync -av --include='*versions*.yml' --exclude='*' $(REMOTE_HOST):$(REMOTE_OUTDIR)/pipeline_info/ .

     %.parquet: %.tsv.gz
     	Rscript ../scripts/convert_to_parquet.R $< $@

     %.parquet: %.tsv
     	Rscript ../scripts/convert_to_parquet.R $< $@
     ```
     The converter uses DuckDB, so it needs the `duckdb` and `DBI` R packages, which
     `duckplyr` (needed to read the result) pulls in; ask before installing `duckplyr`
     if it isn't already there.
     It streams the file, so tables larger than memory convert fine.
6. Since fetched files now land directly in `data/` with whatever names the pipeline gave
   them, per-subdirectory `.gitignore` entries no longer make sense. Instead, check whether
   the project's `.gitignore` already ignores everything under `data/` except the tracked
   scaffolding; if not, add:
   ```
   data/*
   !data/Makefile
   !data/.gitkeep
   ```
   The whole point of fetching via `Makefile` instead of committing raw output is defeated
   if `git add .` ends up staging it anyway. `data/sample_table.tsv` (step 1) is the
   deliberate exception — small, hand-authored, and not reproducible by re-running
   anything, so it belongs in git unlike the rest of `data/`. Add `!data/sample_table.tsv`
   alongside the two exceptions above if a sample table exists.

### Same-machine source: symlink instead of steps 3-6

If step 1 established the pipeline's output directory is on **this same machine** rather
than a remote one, skip steps 3-6 above entirely and do this instead — no `ssh` alias, no
`rsync`, no `Makefile` fetch target:

1. Symlink the same files step 2 identified straight into `data/`, e.g. for `ampliseq` before 3.0:
   `ln -s <outdir>/dada2/*.tsv data/` (and `ln -s <outdir>/pipeline_info/*versions*.yml
   data/`); for `metatdenovo`/`magmap`/`ampliseq` 3.0+, symlink
   `<outdir>/summary_tables/*.tsv.gz` instead.
   Look for Parquet files alongside the TSVs (`ls <outdir>/summary_tables/*.parquet`).
   If they exist, symlink them too and use them.
   If not, offer to build them with `scripts/convert_to_parquet.R`, as in step 5 above
   (ask first, with the same explanation).
   It works fine against a symlinked source: `read_tsv()` and friends follow symlinks
   transparently.
   The converted `.parquet` files are generated, not symlinks, so list them by name in
   `.gitignore`.
2. **Commit the symlinks directly** rather than gitignoring `data/*` — a symlink is just a
   short path string, not the actual data, so there's nothing to protect against
   accidentally committing (unlike step 6's rsync-fetched files). Simpler than steps 4/6's
   `Makefile`-target-plus-gitignore-exception dance, and sidesteps the whole class of
   `make` pattern-rule ordering bugs steps 3-5 had to work around.
3. **Tell the student clearly that this makes the project only usable on this machine** —
   the symlinks point at an absolute path that won't exist anywhere else, so they'll be
   dangling (broken) if this repo is ever cloned onto a different computer. If they think
   they'll need to work on this project from elsewhere later, use the remote `rsync`
   approach (steps 3-6) instead, even though the source happens to be local right now.

