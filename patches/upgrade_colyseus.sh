#!/usr/bin/env bash

wd=$(dirname $0)
my=$wd/../Assets/Scripts/lib/colyseus
version=$wd/version.txt
function rev() {
  repo=$wd/$1
  rm -rf $repo
  git clone -q https://github.com/colyseus/colyseus-defold.git $repo
  pushd . > /dev/null
  cd $repo
  id=$(git log --reverse --ancestry-path $2..master --oneline | head -1 | cut -d' ' -f1)
  echo ${id:-$2}
  git reset -q --hard $id
  popd > /dev/null
}
function dir() {
  echo $wd/$*/colyseus
}
function list() {
  gfind $* -name "*.lua" -printf "%P\n"
}
echo $(rev you $(rev old $(cat $version)^)) > $version
old=$(list $my | sort)
new=$(list $(dir you) | sort)
for file in $(comm -23 <(echo "$old") <(echo "$new")); do
  rm $my/$file
done
for file in $(comm -13 <(echo "$old") <(echo "$new")); do
  folder=$my/$(dirname $file)
  mkdir -p $folder
  install $(dir you)/$file $folder
done
for file in $(comm -12 <(echo "$old") <(echo "$new")); do
  myfile=$my/$file
  diff3 -mE $myfile $(dir old)/$file $(dir you)/$file | sponge $myfile
done
