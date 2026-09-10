# dltemplates

Templates for various programming languages and tasks.

## Initialize project directory structure

If you want to organize your analysis project like Daniel does, there's a script here: `setup_project.sh`.
To run that requires that you first clone this repository. 
For example:

```bash
cd ~/dev # Assuming you have a dev directory in your home directory
git clone https://github.com/erikrikarddaniel/dltemplates.git
cd ~/projects # Assuming you have a projects directory
~/dev/dltemplates/setup_project.sh my_new_analysis # Creates the analysis directory
```

The above will create a `git` repo in `~/projects/my_new_analysis` with a directory structure suitable for analyses, a `.screenrc` file for
`screen` users, a `my_new_analysis.qmd` Quarto document to start your analysis in.
It will also copy a `CLAUDE.md` that contains instructions for Claude.

### For users of Claude Code

If you run Claude Code, it knows a bit about the directory structure, so you can instruct it to e.g. "Setup Makefiles to fetch data from
my metatdenovo run. Files are here: `ssh-name:/path/to/metatdenovo/results/summary_tables`".
It might ask you to create an alias for the `ssh-name` so you don't have to use the long form `user@machine.domain.se` and make sure
that the name used can be used by other users of your analysis repo.
You can also ask it to: "Add a sanity check to the qmd".

*If you don't want to clone the repo yourself* and run Claude Code, you can just download the `project_template/CLAUDE.md` to an empty
analysis directory, start Claude Code and ask it to "Setup this directory".
That can look like this:

```bash
mkdir -p ~/projects/my_new_analysis # Create an empty directory
cd ~/projects/my_new_analysis
curl https://raw.githubusercontent.com/erikrikarddaniel/dltemplates/refs/heads/master/project_template/CLAUDE.md > CLAUDE.md
claude
```
