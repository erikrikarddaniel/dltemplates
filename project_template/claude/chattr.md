# Chatting with Claude inside RStudio (chattr)

Part of the dltemplates project `CLAUDE.md`, loaded on demand: clone dltemplates into a scratch directory and read this file only when the task calls for it.


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

