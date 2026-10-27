# CLAUDE.md

This file is both a **one-time setup trigger** and **ongoing documentation** for a project
scaffolded from https://github.com/erikrikarddaniel/dltemplates. It is meant to be the only
file a new project starts with — copy just this file into an empty directory (no `git clone`
required) and start a Claude Code session there.

## Communication style

The students using this template are often new to R and the command line — be direct and
concise, not verbose.

- Answer the question, then stop. Skip preamble ("Great question!", "I'd be happy to
  help..."), skip recaps of what was just asked, skip restating the plan before doing it.
- Avoid AI-assistant stock phrases: "Let's dive into...", "It's worth noting that...",
  "leverage", "seamless", "robust solution", "comprehensive", "ensure that". Say the plain
  thing instead.
- No unearned enthusiasm or hedging. State what's true, what changed, what to do next.
- Short sentences. One idea per sentence. Match response length to the question — a
  one-line answer doesn't need three paragraphs of framing around it.

## Code comments

- Default to no comment. Code shows *how*; comment only to carry *why* — a non-obvious
  constraint, deliberate deviation, gotcha, or workaround.
- Never narrate the code ("loop over users", "parse the body"), restate names/types/
  signatures, or mark block ends.
- Never narrate the change ("fixed X", "updated to Y", "as requested"). A comment must
  read correctly to someone seeing the file fresh who never saw the diff; change context
  belongs in the commit message.
- Delete by default. A comment that just restates a decision the code already reflects —
  "1 vCPU is deliberate", "right-sized from prod" — is dead weight even when it points to
  a doc: the doc is where anyone questioning it looks anyway. Keep inline only what a
  reader needs *at that line* and can't get from the code — a non-obvious invariant/
  constraint ("timeout must stay < interval — ALB rule") or a cross-file sync obligation
  ("keep in sync with the router's TGs").
- Comments must stand on their own with any link removed — encode the substance, never a
  pointer as a substitute for it. Banned: specs, section numbers, design docs —
  point-in-time artifacts that get superseded and rot ("spec §7" is the canonical case).
  Fine: a maintained doc/README at a stable path — and when the *why* is a system-level
  narrative ("why it's built this way"), extract it there as a *pure* extraction: not an
  inline block, and not a comment that merely points to the doc. What stays inline are the
  non-obvious local details, which reference the doc only when a reader genuinely needs it
  *at that line* — a pointer-only comment generally shouldn't exist at all. Tickets,
  Confluence, RFCs, permalinks stay fine as trailing breadcrumbs.
- Occam's razor on every comment you *keep*, not just the ones you delete. "Carries a real
  *why*" and "is worded minimally" are independent judgments — a genuine *why* can still be
  3x too long, and "it's a real why" is not license to keep the wording verbatim. Keep only
  the one non-obvious fact a reader needs *at that line*, in the fewest words; cut the
  mechanism the code already shows, where a value is consumed downstream, the
  consequence-of-the-consequence, and justification-of-the-justification. A 5-line block
  almost never survives intact — suspect it on sight; the razored answer is sometimes zero.
- A one-line summary on a public function/endpoint is fine; inline restatement of a single
  clear line never is.
- TODOs are fine and don't need issue IDs — but a TODO is a marker, not a substitute for
  doing the work in scope.

## If the project structure below doesn't exist yet

Check the current directory for `data/`, `scripts/`, `figures/`, `Makefile`, and a `*.Rproj`
file. If any of them are missing, this project hasn't been scaffolded yet — do the following
before anything else, and before addressing whatever the user actually asked for:

1. If the current directory's name looks generic (e.g. `untitled`, `new folder`, `test`),
   ask the user first whether to rename the folder before continuing — its name becomes the
   project name, used for the `.screenrc` session name and the `.qmd` report filename.
2. `git clone --depth 1 https://github.com/erikrikarddaniel/dltemplates <tmpdir>` into a
   scratch/temp directory — never inside the project directory itself, and this clone's own
   `.git` history must not end up in the project.
3. From inside the project directory (the one containing this `CLAUDE.md`), run
   `<tmpdir>/setup_project.sh` with **no argument**. It detects that the directory already
   exists, uses its basename as the project name, and builds the full structure in place —
   see "Project structure" below for exactly what it creates. (Use the absolute path to the
   script; running it via a relative path after the temp clone could break once the script's
   own `cd` changes the working directory.)
4. Delete the temporary clone.
5. Tell the user what was created and that they can open `project.Rproj` in RStudio or start
   editing `scripts/`.

`setup_project.sh` itself does the `git init .` / `git add .` (this `CLAUDE.md` gets committed
along with everything else) and deliberately does not create a commit — leave that for the
user's first commit.

If the structure already exists, skip all of the above — this file is now just documentation.

## Keeping this file up to date

The template this file came from, `project_template/CLAUDE.md` in dltemplates, changes over time.
The last line of this file records when it was last compared with the template, as an HTML comment: `<!-- dltemplates sync: checked YYYY-MM-DD -->`.
`setup_project.sh` writes it when it creates the project.

At the start of a session, before the first task, run `tail -1 CLAUDE.md`.
If the marker is missing or more than 30 days old, ask once whether you may check for an updated template.
Don't check without a yes, and don't interrupt a task already under way to ask.
The student can also ask for the check at any time.

On a student's own branch (see "Working on your own branch"), skip this check and don't edit this file.
The supervisor runs it on the default branch (`main` or `master`), and the changes arrive with the merge from it.

On a no, set the marker to today's date, so you don't ask again for 30 days.
On a yes:

1. `git clone --depth 1 https://github.com/erikrikarddaniel/dltemplates <tmpdir>` into a scratch/temp directory, never inside the project, and delete it when done.
2. `diff -u -I 'dltemplates sync' CLAUDE.md <tmpdir>/project_template/CLAUDE.md` (the `-I` skips the marker line).
3. Sort the differences.
   Text only in the template is a candidate update.
   Text only here is the student's own addition or a project-specific note: keep it.
   A passage changed on both sides is a conflict: show both versions and let the student choose.
4. Tell the student in plain, short terms what changed in the template, and ask which changes to apply, or all.
   Apply them as edits to this file.
   Never replace this file with the template's copy; that would delete the student's additions.
5. If the new instructions rely on a file the project lacks (for example a script under `scripts/` that the template's `setup_project.sh` now copies), say so and offer to copy it from `<tmpdir>/R/`.
   Don't overwrite a file the student has edited.
6. Set the marker to today's date, delete the clone, and offer to commit the change.
   Commit only if the student agrees.

## Project structure

- `data/` — raw/intermediate data, built via `data/Makefile`. Nothing here is meant to be
  edited by hand; it's regenerated by rules you add to `data/Makefile`.
- `scripts/` — analysis/processing scripts. Includes `convert_to_parquet.R` by default, a
  generic TSV(.gz)-to-Parquet converter for pipeline output that doesn't already ship
  Parquet copies — see "Guides loaded on demand" below.
- `figures/` — generated plots (`*.png`, `*.pdf` are gitignored — figures are build products,
  not source).
- `docs/` — general project documentation: free-form notes, protocols, write-ups — anything
  that isn't the `.qmd` report itself or code. Not tied to Quarto rendering or GitHub Pages,
  just a place to keep documentation out of the project root.
- `Makefile` (root) — currently just delegates to `data/Makefile` (`cd data; make all`).
  Extend it as the project grows.
- `project.Rproj` — RStudio project file (`BuildType: Makefile`), so RStudio's Build pane
  runs the root `Makefile`. Remind students to always open the project via this file (not
  by opening individual scripts/documents directly) — that's what puts R's working
  directory at the project root. `setwd()` and absolute paths in R scripts or `.qmd` files
  should never be needed and shouldn't be added; they break as soon as the project moves or
  someone else clones it, defeating the point of committing the `.Rproj` file at all.
- `CLAUDE.md` (this file) — copied in by `setup_project.sh` itself, same as `project.Rproj`
  or `tools.bib` below, so every project scaffolded this way carries its own copy of this
  documentation, not just ones bootstrapped from a student's pre-seeded copy.
- `.screenrc` — a GNU screen layout with windows for `rstudio`, `data`, `scripts`, `man`,
  and `root`, opened automatically in the right directory. Run `screen` in the project root
  to use it (optional — nothing else depends on it).
- `.gitignore` — tuned for bioinformatics projects: keeps large/raw sequence and alignment
  files (`*.fastq*`, `*.fna`, `*.gz`, `*.dmnd`, etc.) out of git.
- `tools.bib` — a shared BibTeX library of tool/database citations, copied in from
  dltemplates. Add citations for tools/databases you use to your project's `bibliography.bib`
  instead of editing this file, unless the citation is generic enough to be useful in other
  projects too.
- `bibliography.bib` — project-specific references. Starts empty.
- `grateful-refs.bib` — **not** created by setup; the `grateful` R package generates this
  automatically (via `cite_packages()`) the first time the `.qmd` report is rendered, listing
  exact versions of R packages used.
- `<project-name>.qmd` — a Quarto report with a fixed section skeleton (Version history,
  Summary, Introduction, Materials and Methods, Results, Discussion, References) and a
  packages-used table. All three `.bib` files above are wired into its bibliography.

## Working on your own branch

In a supervised project the student works on a branch of their own, and the supervisor merges it into the default branch (`main` or `master`, whichever the project uses) after reviewing it, for instance before a meeting.
This section applies when that is the case.
The aim is that the student never has to resolve a merge conflict or touch the default branch.

At the start of a session, run `git branch --show-current`.
If it is a branch other than `main` or `master`, follow the rules below.
If it is `main` or `master` and the project has a remote, ask once whether the student works under a supervisor who merges their work.
On a yes, ask for a short branch name (their first name in lower case is fine), run `git switch -c <name>`, and push it with `git push -u origin <name>` after confirming with the student.
On a no, carry on on the default branch and skip this section for the rest of the session.

Rules on the student's branch:

- Never commit to, push to or merge into the default branch (`main` or `master`).
  The supervisor does that.
- Never force-push, rebase or otherwise rewrite commits that are already pushed.
- Commit when a piece of work is finished and at the end of every session.
  Write the message as one or two sentences saying what was done and why, because the supervisor reads them.
  Push the branch after committing, and before a meeting with the supervisor.
  Ask once per session for permission to commit and push to the branch; a yes covers the rest of that session.
- Don't edit this file, and skip the template check in "Keeping this file up to date".
  The supervisor does that on the default branch, and the changes arrive with the merge below.
  Notes specific to the student's work go in `NOTES.md`.

Bringing in changes from the default branch, at the start of a session before the first task:

1. Run `git status`.
   If there are uncommitted changes, offer to commit them first, because a merge needs a clean working tree.
2. Run `git pull`, then `git fetch origin`, then `git merge origin/<default>`, where `<default>` is whichever of `main` or `master` exists on the remote.
3. If nothing new came in, say nothing.
   Otherwise tell the student in a sentence or two what changed (`git diff --stat ORIG_HEAD HEAD`).
4. If there are conflicts, resolve them yourself; don't ask the student to.
   For files the supervisor maintains (this file, `scripts/`, the `Makefile`s, `.gitignore`), take the version from the default branch, unless the student has made a deliberate edit, in which case combine the two.
   For the student's own analysis files, keep the student's work and add the changes from the default branch around it.
   Then check that no markers are left (`grep -rn '^<<<<<<<\|^>>>>>>>' .`), check that the project still runs where that is cheap, and commit with the default merge message.
   Tell the student briefly which files conflicted and how you resolved them.
5. If you can't resolve a conflict with confidence, for example because two edits contradict each other in meaning, run `git merge --abort`.
   Tell the student that their work is untouched, that the supervisor needs to look at this, and what the conflict is.
   Carry on working on the branch without the merge.

## Guides loaded on demand

These procedures are long and used rarely, so they live in dltemplates, not in this file.
When the task matches, clone dltemplates into a scratch directory outside the project (`git clone --depth 1 https://github.com/erikrikarddaniel/dltemplates <tmpdir>`), read the guide, follow it, and delete the clone.
Don't read a guide before the task calls for it.

| Task | Guide (under `<tmpdir>/project_template/claude/`) |
|---|---|
| Get pipeline output (`ampliseq`, `metatdenovo`, `magmap`) into `data/`, wire `data/Makefile`, build Parquet | `fetch-pipeline-output.md` |
| A "sanity check": NMDS plus a stacked phylum barplot as `sanity_check.qmd` | `sanity-check.md` |
| Create a GitHub remote, push, or fix `git push` authentication | `github-remote.md` |
| Chat with Claude inside RStudio (`chattr`) | `chattr.md` |
| Supervisor asks to review a student branch (supervisor sessions only) | `supervisor-review.md` |

Facts every session needs, whichever guide applies:

- The pipeline output lives elsewhere (usually an HPC cluster) and is far too large to commit. It reaches `data/` through `data/Makefile` (`rsync` over an `ssh` config alias) or, if on this machine, through committed symlinks.
- The analysis templates read Parquet, not TSV. Ask before building Parquet files or installing `duckplyr`.
- Never commit `data/` contents (except `data/Makefile`, `data/.gitkeep`, `data/sample_table.tsv` and symlinks), credentials, or `.Rhistory`.

## Working with Parquet tables in R

Read Parquet with `duckplyr`, not `arrow` or `read_tsv()`, so the table stays on disk until a result is needed:

```r
library(duckplyr)
counts <- read_parquet_duckdb("data/<name>.parquet", prudence = "stingy")
```

`prudence = "stingy"` makes `duckplyr` stop with an error when a verb can't run in DuckDB, instead of silently loading the whole table into R.
Keep the table lazy and `collect()` only small summaries.
When writing or editing analysis code for these tables:

- Use `.by`, not `group_by()`: `summarise(x = sum(y, na.rm = TRUE), .by = c(sample, taxon))`.
  `mutate(.by = )` works too; `filter(.by = )` does not, and neither does `group_by()` followed by `summarise()`.
- Give `sum()` and `mean()` `na.rm = TRUE`; inside `mutate(.by = )`, `duckplyr` can't translate them without it.
- Not translatable (checked with `duckplyr` 1.2.1, so test before relying on a newer one): `as.character()`, `case_when()`, `ifelse()` (`if_else()` works), `separate()`, `pivot_wider()`, `pivot_longer()`, `factor()`.
  Aggregate first, `collect()` the small result, then use them on the local table.
- Convert the types once, when making the Parquet file (`scripts/convert_to_parquet.R` keeps `sample` as text), rather than casting in every query.
- In SQL, `x NOT IN (a, b, nullable_column)` returns `NULL` when the column is `NULL`, so the row is dropped.
  Use `IS DISTINCT FROM` for each value instead.
- For community-ecology distances on a long sample-by-taxon table, use `ecolongr` (`el_vegdist()`, `el_decostand()`) and pass the result to `vegan`.

## Moving heavy work out of the Quarto document

Remind students that anything computationally heavy shouldn't live inline in a `.qmd` —
it re-runs on every render, which gets slow and makes rendering flaky. Instead, it belongs
in a standalone R script under `scripts/`, wired into `data/Makefile`'s `all` target so it
runs once, via RStudio's Build button (the same `make` chain used for fetching data: root
`Makefile` → `data/Makefile`), rather than every time someone knits the report. The script
writes its result into `data/`, and the `.qmd` just reads that finished file.

Two situations this comes up for a lot, worth raising proactively rather than waiting for
the student to hit the problem:

- **Consolidating taxonomies**: for each ASV (`ampliseq`) or ORF (`metatdenovo`/`magmap`),
  several fetched files may each assign a candidate taxonomy, and something has to decide
  which one to settle on per feature. That decision logic is exactly the kind of thing that
  belongs in a `scripts/` script, not inline in the report.
  Pitfalls, from a `metatdenovo` project with RefSeq, MarFERReT and GTDB tables:
  - A row in a taxonomy table is not a classification.
    The `metatdenovo` taxonomy tables have a row for every ORF, with `NA` ranks where nothing matched.
    Test `domain IS NOT NULL`, not that the ORF has a row.
    GTDB writes `root` for hits it can't place in a domain; treat that as unclassified too.
  - Let the later databases classify ORFs the first one left without a domain, not only ORFs it had already placed.
    In that project it cut the TPM without a domain in the metatranscriptomes from 63% to 35%.
  - NCBI-derived ranks have gaps.
    Dinoflagellates, pelagophytes and other protists have a class and below but no phylum, because the clade above the class has no phylum rank.
    A phylum plot then shows most eukaryotes as unassigned.
    Fill the gap with the closest named clade from the lineage string and record it in a column such as `phylum_source` (`rank` or `clade`), so plots can mark the placeholders.
- **Large statistical tests**: run once and their result cached as a `data/` file, instead
  of being recomputed on every render.

When such a script is a rule in `data/Makefile`:
- List the script itself as a prerequisite, so changing its logic rebuilds the table.
  Pass only the data files to it, e.g. `$(filter %.parquet,$^)`.
- If the Parquet files are built in another directory and symlinked into `data/`, add `.SECONDARY:`.
  Without it `make` deletes the files it built through the pattern-rule chain as intermediates, and the next run rebuilds all of them.

As with fetched pipeline output, the result of these scripts is often too large to commit
— the blanket `data/*` `.gitignore` pattern (see "Guides loaded on demand") already covers
that, no extra bookkeeping needed as long as the script's output stays under `data/`.

There's no settled convention yet for exactly how these scripts should be structured (input
sources, output file naming, how granular the Makefile rules should be, whether some
version of `misc/makefile.library`'s `.makecall` provenance-recording pattern is worth
reusing here). Don't assume an approach — when a task like this comes up, ask the student
(or the user) how they want to structure it before writing the script or the Makefile rule.

