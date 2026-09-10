# dltemplates

Templates for various programming languages and tasks.

## Initialize project directory structure

If you want to organize your analysis project like Daniel does, there's a script here: `setup_project.sh`.
To run that requires that you first clone this repository. 
For example:

```bash
cd ~/dev
git clone https://github.com/erikrikarddaniel/dltemplates.git
cd ~/projects
~/dev/dltemplates/setup_project.sh my_new_analysis
```

The above will create a `git` repo in `~/dev/my_new_analysis` with a directory structure suitable for analyses, a `.screenrc` file for
`screen` users, a `my_new_analysis.qmd` Quarto document to start your analysis in.
It will also copy a `CLAUDE.md` that contains instructions for Claude.

### For users of Claude Code

If you run Claude Code, it knows a bit about the directory structure, so you can instruct it to e.g. "Setup Makefiles to fetch data from
my metatdenovo run. Files are here: `ssh-name:/path/to/metatdenovo/results/summary_tables`".
You can also ask it to: "Add a sanity check to the qmd".

*If you don't want to clone the repo yourself* and run Claude Code, you can just download the `project_template/CLAUDE.md` to an empty
analysis directory, start Claude Code and ask it to "Setup this directory".
That can look like this:

```bash
mkdir -p ~/projects/my_new_analysis
cd ~/projects/my_new_analysis
curl https://raw.githubusercontent.com/erikrikarddaniel/dltemplates/refs/heads/master/project_template/CLAUDE.md > CLAUDE.md
claude
```
