# Setting up a GitHub remote

Part of the dltemplates project `CLAUDE.md`, loaded on demand: clone dltemplates into a scratch directory and read this file only when the task calls for it.


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
  the cluster fetch alias (see `fetch-pipeline-output.md`) — an SSH keypair, just registered to their own GitHub
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

