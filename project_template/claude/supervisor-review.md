# Reviewing a student branch

Part of the dltemplates project `CLAUDE.md`, loaded on demand: clone dltemplates into a scratch directory and read this file only when the task calls for it.


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

