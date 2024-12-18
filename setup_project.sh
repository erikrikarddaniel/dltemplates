#!/bin/sh

# Sets up a standard project directory.

pname=$1
template_path=$(dirname $0)
mkdir $pname
cd $pname
mkdir data
touch data/.gitkeep
mkdir scripts
touch scripts/.gitkeep
mkdir figures
echo '*.png' >> figures/.gitignore
echo '*.pdf' >> figures/.gitignore

echo 'all:' > Makefile
echo '	cd data; make all' >> Makefile
echo 'all:' > data/Makefile

cp $template_path/R/project.Rproj .
sed "s/__PROJNAME__/${pname}/" $template_path/misc/screenrc | sed '/__INSERTPOINT__/a chdir $ROOT/scripts\nscreen -t scripts' | sed '/__INSERTPOINT__/a chdir $ROOT/data\nscreen -t data' > .screenrc
cp $template_path/misc/gitignore .gitignore
cp $template_path/misc/tools.bib .
cp $template_path/R/quarto.qmd ${pname}.qmd

touch bibliography.bib

git init .
git add .
