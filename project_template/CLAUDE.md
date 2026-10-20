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
  Parquet copies — see "Fetching pipeline output into `data/`" below.
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

## Setting up a GitHub remote

`setup_project.sh` only runs `git init` locally — the project isn't backed up or shareable
until it has a remote. Help the student with this once the local scaffold exists:

1. Check whether they already have a GitHub account. If not, they need to create one
   manually at https://github.com/join — sign-up needs email verification, so nothing here
   can be done on their behalf.
2. Create a **private** repository for the project. Prefer whichever of these actually
   works in the student's environment:
   - If the `gh` CLI is installed and already authenticated (`gh auth status`), it can be
     created directly: `gh repo create <name> --private --source=. --remote=origin --push`.
     Confirm the repo name and that private is what they want *before* running it — this
     publishes something to their GitHub account, so don't run it unprompted.
   - Otherwise, walk them through the web UI: log in, go to https://github.com/new, enter a
     name (the project directory's name is a good default), select **Private**, and leave
     "Initialize this repository with a README/.gitignore/license" unchecked — the local
     project already has these, and initializing remotely would create a repo history that
     conflicts with the one already committed locally. GitHub shows a remote URL afterward.
3. If step 2 didn't already do it via `--remote=origin`, add that URL as a remote:
   ```
   git remote add origin <url-from-github>
   ```
   (`git remote set-url origin <url>` instead, if `origin` is already set to something else)
4. Push and set upstream tracking — check the local default branch name first
   (`git branch --show-current`, likely `master` or `main`) rather than assuming one:
   ```
   git push -u origin <branch-name>
   ```
   Confirm with the student before this first push, same as any other push.

### Authentication

Plain HTTPS with a username and password no longer works for `git push` — GitHub removed
that in 2021, so an unprepared HTTPS remote just fails with a confusing error rather than
prompting cleanly. Two ways around it, in order of preference:

- **`gh auth login`**, if the `gh` CLI is present (step 2's first option already relies on
  this). It's a browser-based device-code login that configures git's credential helper
  automatically — no keys to generate, no tokens to copy anywhere. Least setup when it's
  available.
- **SSH keys**, otherwise. Conceptually the same thing the student is already learning for
  the cluster fetch alias above — an SSH keypair, just registered to their own GitHub
  account this time instead of a shared cluster login. Treat the keypair as belonging to
  the *student*, not the machine: one keypair, reused on every computer they work from, is
  the convention here — not a fresh one per machine.
  1. Check for an existing key first — on this machine, and on any other machine the
     student already uses (their own laptop, a department computer, etc.):
     `ls ~/.ssh/id_ed25519.pub`. If one exists anywhere already, copy that same private and
     public key file over to the new machine (a USB drive, or `scp` between two machines
     the student already has access to — never by email or pasted into chat, since the
     private key is as sensitive as a password) rather than generating a second keypair.
     Skip to step 3 once the key is in place.
  2. Only if no key exists anywhere yet, generate one: `ssh-keygen -t ed25519 -C "<their
     email>"`. Accepting the default file location is fine. Use a real, good passphrase —
     that's the recommendation here, not the empty-passphrase shortcut, precisely because
     this one key ends up trusted everywhere (GitHub, and potentially the cluster too), so
     it's worth protecting well:
     - Avoiding having to re-enter the passphrase on every push depends on `ssh-agent`,
       which behaves differently per OS:
       - **macOS**: an agent already runs, but forgets keys after a reboot by default. Add
         `UseKeychain yes` and `AddKeysToAgent yes` to `~/.ssh/config`, then run
         `ssh-add --apple-use-keychain ~/.ssh/id_ed25519` once — after that it persists via
         the system Keychain.
       - **Linux**: most desktop environments auto-start an agent tied to the login
         keyring (prompts once at login, remembers afterward). On a headless machine or a
         minimal window manager there's no agent unless started manually, each session:
         `eval "$(ssh-agent -s)"` then `ssh-add ~/.ssh/id_ed25519`.
       - **Windows**: the built-in "OpenSSH Authentication Agent" service is disabled by
         default — enable it once from an elevated PowerShell:
         `Set-Service ssh-agent -StartupType Automatic; Start-Service ssh-agent`. Git Bash
         also bundles its own, separate agent; if a push keeps re-asking for the
         passphrase, that's usually two agents not sharing state, not a broken key.
     - Regardless of OS, `ssh-add -l` shows what's currently loaded and `ssh-add
       ~/.ssh/id_ed25519` (re-)loads it — the one command that's the same everywhere, worth
       reaching for whenever a push unexpectedly asks for the passphrase again.
     - An empty passphrase sidesteps all of the above and works identically on every OS —
       mention it as an option that exists, but it's not the default taught here, precisely
       because it leaves the key file alone as the only thing protecting access.
  3. `cat ~/.ssh/id_ed25519.pub` and have them paste the output into GitHub → Settings →
     SSH and GPG keys → New SSH key.
  4. Verify with `ssh -T git@github.com` — it should greet them by GitHub username, not
     ask for a password.
  5. Use the SSH form of the remote URL, `git@github.com:<user>/<repo>.git` (both the web
     UI and `gh repo create` offer this alongside the HTTPS one).

Avoid a manually-pasted Personal Access Token unless neither of the above is available —
tokens expire and need scopes configured, which is more to explain than either option here.

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

## Reviewing a student branch

Do this only when the supervisor asks for it, for instance before a meeting.
It is written for the supervisor's session; a student's session does not review its own branch.
The branch is `origin/<branch>`, and `<default>` is the default branch: `main` or `master`, whichever the project uses.

1. Make sure the working tree is clean, then `git fetch origin`, `git switch <default>` and `git pull`.
2. Get an overview: `git log --oneline --no-merges <default>..origin/<branch>` and `git diff --stat <default>...origin/<branch>`.
3. Read the full diff (`git diff <default>...origin/<branch>`) for research soundness, not only for code errors.
   Check in particular:
   - Are all samples in the metadata accounted for, and is every exclusion stated and justified?
   - Are filters, thresholds and transformations stated in Materials and Methods with a reason?
   - Do the pipeline version and the database in the text match the data that was fetched?
   - Are the statistical choices (distance, transformation, rarefaction, correction for multiple tests) appropriate for the question?
   - Are the claims in the Discussion supported by the figures, and no stronger than the data allow?
   - Has anything been committed that shouldn't be: data files, credentials, large outputs, `.Rhistory`?
   - Were files the supervisor maintains edited (this file, scripts copied from the templates, the `Makefile`s)?
   - Are tools and databases cited from `tools.bib`?
4. Render the report from the branch.
   Try the merge without committing it: `git merge --no-commit --no-ff origin/<branch>`, render, then `git merge --abort` unless the supervisor wants to go ahead.
   If the data isn't available locally, say so and review from the diff alone.
5. Report to the supervisor in order of importance: must fix before merging, questions for the student, minor points.
   Keep what was checked by running apart from what was only read, and state what couldn't be checked.
   If the supervisor wants to send feedback to the student, draft it as a short text for them to send; don't contact the student yourself.
6. Merge only when the supervisor says so, and not while must-fix points remain unless they say to anyway.
   Use `git merge --no-ff origin/<branch>`, with a message that names the student and what the merge brings.
   Resolve any conflict yourself and show the supervisor the resolution before committing.
   Push `<default>` only after confirming with the supervisor.
   The student needs to do nothing, because the merge reaches their branch at the start of their next session.

## Chatting with Claude inside RStudio (`chattr`)

Optional, but worth setting up — [`chattr`](https://mlverse.github.io/chattr/) adds a chat
pane to RStudio (and Positron) that talks to an LLM, including Claude, without leaving the
IDE. It's built on `ellmer`, Posit's general R-to-LLM package, which it pulls in as a
dependency.

1. Install: `install.packages("chattr")` (and `install.packages("usethis")` too, if not
   already present — used in the next steps).
2. Get an Anthropic API key from https://console.anthropic.com. This is separate from a
   claude.ai subscription and needs its own billing set up (pay-as-you-go credits), unless
   using a shared/institutional key someone else is providing. Whether each student gets
   their own key or the class shares one is a course-logistics decision, not a technical
   one — worth settling ahead of time rather than per-student.
3. Store the key as an environment variable rather than pasting it into a script:
   `usethis::edit_r_environ()` opens `.Renviron` for editing; add a line
   `ANTHROPIC_API_KEY=sk-ant-...`, save, and restart R for it to take effect.
4. Tell `chattr` to default to Claude: add `options(.chattr_chat = ellmer::chat_anthropic())`
   to `.Rprofile` (open it with `usethis::edit_r_profile()`), so it's set every session
   instead of needing to be typed each time.
5. Open the chat pane via Tools → Addins → Browse Addins → "Open Chat", or bind it to a
   keyboard shortcut from that same Addins browser for quicker access.

### Does this work on RStudio Server (a remote machine)?

Yes, and for a simple reason: authentication here is just an API key sent as an HTTP
header directly from the R process to Anthropic's servers — there's no browser-based OAuth
redirect step involved (unlike, say, `gh auth login`), so it doesn't matter whether R is
running locally or on a remote server. Two things that *do* matter:

- The `.Renviron` edited in step 3 has to be the one on whichever machine actually runs the
  R process. On RStudio Server that's the server's own home directory, edited from inside
  that server-hosted RStudio session — not the student's laptop, which the server-side R
  session never sees.
- The server needs outbound network access to `api.anthropic.com`. Most machines have this
  by default, but an HPC cluster or an institutionally locked-down server sometimes doesn't
  — worth checking with whoever administers it if the chat pane can't connect.

## Fetching pipeline output into `data/`

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
   the sanity check (see below). If they have one, copy it to `data/sample_table.tsv`.
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
   The analysis templates read Parquet (see "Working with Parquet tables in R" below),
   because it is faster to read and DuckDB loads only what a query needs.
   If there are none, offer to build them (step 5); don't build them without asking.
   Support is new and differs across these three pipelines (checked 2026-09), so
   don't assume from the pipeline name alone:
   - `magmap` (v1.2.0+, 2026-08-11): opt-in via `--save_parquet`; when used, every
     `summary_tables/*.tsv.gz` file gets a same-named `*.parquet` sibling.
   - `ampliseq` (3.0.0+, released 2026-10-09): every `summary_tables/ampliseq.*.tsv.gz`
     has a `.parquet` twin, on by default, opt-out via `--skip_parquet_summary`.
     Runs made with a version before 3.0 have neither.
   - `metatdenovo`: not implemented yet (tracked as nf-core/metatdenovo#473) — no run will
     have Parquet output.
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

## Adding a "sanity check"

When a student asks for a "sanity check" (or similar — a first-look diagnostic on their
pipeline output), this means a specific deliverable: an NMDS ordination plus a stacked
phylum-level taxonomy composition barplot, as a new `sanity_check.qmd`. Prerequisites:
pipeline output already fetched into `data/` as Parquet files (see above, including a sample
table if one exists — needed to colour/shape the NMDS).
If `data/` has only TSVs, go back to step 5 of the fetching instructions and offer to
convert them first; the templates read Parquet only.

1. `git clone --depth 1 https://github.com/erikrikarddaniel/dltemplates <tmpdir>` into a
   scratch/temp directory, same as the initial project bootstrap — never inside the
   project directory, and delete it once done.
2. Copy `<tmpdir>/R/sanity_check_<pipeline>.qmd` to `sanity_check.qmd` in the project root
   (`<pipeline>` is `ampliseq`, `magmap`, or `metatdenovo`, matching whichever pipeline
   step 1 of the fetching instructions above already established), and
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
— the same blanket `data/*` `.gitignore` pattern from the section above already covers
that, no extra bookkeeping needed as long as the script's output stays under `data/`.

There's no settled convention yet for exactly how these scripts should be structured (input
sources, output file naming, how granular the Makefile rules should be, whether some
version of `misc/makefile.library`'s `.makecall` provenance-recording pattern is worth
reusing here). Don't assume an approach — when a task like this comes up, ask the student
(or the user) how they want to structure it before writing the script or the Makefile rule.

## Principles

*(draft — to be refined)*

The structure separates raw/derived data (`data/`), code (`scripts/`), and generated output
(`figures/`, the rendered `.qmd`) so that everything except `data/` and the figures can be
regenerated from source and safely committed to git, while large data files are kept out of
version control by `.gitignore`. The `Makefile` chain and the `.makecall` convention (see
`misc/makefile.library` in dltemplates) exist to record *how* each data file was produced —
tool version, parameters, and inputs — next to the file itself, for reproducibility.
