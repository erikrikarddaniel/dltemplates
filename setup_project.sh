#!/bin/sh

# Sets up a standard project directory.
#
# Usage: setup_project.sh [dirname]
#
# With a dirname argument: creates it if it doesn't exist yet (original
# behaviour), or, if it already exists, sets up inside it as-is -- covers
# e.g. a student who already created the directory (and may have dropped a
# CLAUDE.md into it) before running this script.
#
# With no argument: sets up the current directory in place, using its
# basename as the project name.

template_path=$(cd "$(dirname "$0")" && pwd)

if [ -n "$1" ]; then
    pname=$1
    if [ ! -d "$pname" ]; then
        mkdir "$pname"
    fi
    cd "$pname"
    # Reduce to the basename: a path-like argument (e.g. a/b/myproj) would otherwise
    # leak into the screen session name (breaking the sed below, which uses / as its
    # delimiter) and into the .qmd filename below (which is written relative to the
    # now-current project directory, not the original argument).
    pname=$(basename "$pname")
else
    pname=$(basename "$PWD")
fi

mkdir data
touch data/.gitkeep
mkdir scripts
touch scripts/.gitkeep
cp $template_path/R/convert_to_parquet.R scripts/
mkdir figures
echo '*.png' >> figures/.gitignore
echo '*.pdf' >> figures/.gitignore
mkdir docs
touch docs/.gitkeep

echo 'all:' > Makefile
echo '	cd data; make all' >> Makefile
echo 'all:' > data/Makefile

cp $template_path/R/project.Rproj .
cp $template_path/project_template/CLAUDE.md .
sed "s/__PROJNAME__/${pname}/" $template_path/misc/screenrc | sed '/__INSERTPOINT__/a chdir $ROOT/scripts\nscreen -t scripts' | sed '/__INSERTPOINT__/a chdir $ROOT/data\nscreen -t data' | sed '/__INSERTPOINT__/a chdir $ROOT/docs\nscreen -t docs' > .screenrc
cp $template_path/misc/gitignore .gitignore
cp $template_path/misc/tools.bib .
cp $template_path/R/quarto.qmd ${pname}.qmd

touch bibliography.bib

git init .
git add .
