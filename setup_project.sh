#!/bin/sh

# Sets up a standard project directory.

pname=$1
mkdir $pname
cd $pname
mkdir data
touch data/.gitkeep
mkdir analyses
touch analyses/.gitkeep

cp ~/dev/dltemplates/R/project.Rproj ${pname}.Rproj
sed "s/__PROJNAME__/${pname}/" ~/dev/dltemplates/misc/screenrc | sed '/__INSERTPOINT__/a chdir analyses\nscreen -t analyses' | sed '/__INSERTPOINT__/a chdir data\nscreen -t data' > .screenrc
cp ~/dev/biomakefiles/gitignores/project_root.gitignore .gitignore

git init .
git add .
