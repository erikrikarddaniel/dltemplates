#!/bin/sh

# Sets up a standard project directory.

pname=$1
mkdir $pname
cd $pname
mkdir data
touch data/.gitkeep
mkdir scripts
touch scripts/.gitkeep
mkdir figures
echo '*.png' >> figures/.gitignore
echo '*.pdf' >> figures/.gitignore

cp ~/dev/dltemplates/R/project.Rproj .
sed "s/__PROJNAME__/${pname}/" ~/dev/dltemplates/misc/screenrc | sed '/__INSERTPOINT__/a chdir $ROOT/scripts\nscreen -t scripts' | sed '/__INSERTPOINT__/a chdir $ROOT/data\nscreen -t data' > .screenrc
cp ~/dev/biomakefiles/gitignores/project_root.gitignore .gitignore
cp ~/dev/dltemplates/R/rmarkdown.Rmd ${pname}.Rmd
cp ~/dev/dltemplates/R/quarto.qmd ${pname}.qmd

git init .
git add .
