#!/usr/bin/env bash
GITHUB_REPONAME="ellerenad/ellerenad.github.io"
originalDir=$PWD
tmp="../tmp/ellerenad.github.io"
rm -rf $tmp
mkdir -p $tmp

cp -r _site/. $tmp


cd tmp

git init
git add .
git config commit.gpgsign false
git config user.name "Enrique Llerena Dominguez"
git config user.email ellerenad@hotmail.com
git commit -m "Site updated"
git remote add origin git@github.com:$GITHUB_REPONAME.git
git push --set-upstream origin master

cd $originalDir
