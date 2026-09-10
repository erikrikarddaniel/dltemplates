# dltemplates

Templates for various programming languages and tasks.

## Prerequisites

- **git** — to clone this repository. Usually already installed on Mac/Linux; see [git-scm.com](https://git-scm.com/downloads) if not.
- **[Claude Code](https://code.claude.com/docs/en/quickstart)** — only needed for the "For users of Claude Code" section below; the plain `setup_project.sh` route doesn't require it.

## Initialize project directory structure

If you want to organize your analysis project like Daniel does, there's a script here: `setup_project.sh`.
To run that requires that you first clone this repository. 
For example:

```bash
mkdir -p ~/dev # Create a dev directory in your home directory, if you don't already have one
cd ~/dev
git clone https://github.com/erikrikarddaniel/dltemplates.git
mkdir -p ~/projects # Create a projects directory, if you don't already have one
cd ~/projects
~/dev/dltemplates/setup_project.sh my_new_analysis # Creates the analysis directory -- replace "my_new_analysis" with whatever you want to call your project
```

The above will create a `git` repo in `~/projects/my_new_analysis` with a directory structure suitable for analyses, a `.screenrc` file for
[`screen`](https://opensource.com/article/17/3/introduction-gnu-screen) users (a terminal session manager that keeps commands running even if you
disconnect -- entirely optional, skip it if that means nothing to you), a `my_new_analysis.qmd` [Quarto](https://quarto.org/docs/get-started/)
document to start your analysis in, and a `project.Rproj` file.
Open the project through that `.Rproj` file in RStudio (rather than opening the `.qmd` directly) -- that's what makes RStudio's working
directory match the project root and its Build pane work.
It will also copy a `CLAUDE.md` that contains instructions for Claude.

### For users of Claude Code

If you run Claude Code, it knows a bit about the directory structure, so you can instruct it to e.g. "Setup Makefiles to fetch data from
my metatdenovo run. Files are here: `<ssh-alias>:/path/to/metatdenovo/results/summary_tables`" -- replace `<ssh-alias>` with whatever name
you use for that machine in your own `~/.ssh/config` (or the full `user@machine.domain.se` if you don't have one set up yet).
It might ask you to create such an alias so you don't have to use the long form `user@machine.domain.se`, and make sure
that the name used can be used by other users of your analysis repo.
You can also ask it to: "Add a sanity check to the qmd".

*If you don't want to clone the repo yourself* and run Claude Code, you can just fetch the `project_template/CLAUDE.md` file (shown below
via `curl`) into an empty analysis directory, start Claude Code and ask it to "Setup this directory".
That can look like this:

```bash
mkdir -p ~/projects/my_new_analysis # Create an empty directory
cd ~/projects/my_new_analysis
curl -fsSL https://raw.githubusercontent.com/erikrikarddaniel/dltemplates/refs/heads/master/project_template/CLAUDE.md > CLAUDE.md
claude
```

(`-fsSL` makes `curl` print an error and stop instead of silently writing an error page into `CLAUDE.md` -- if this command runs with no
output, it worked.)
