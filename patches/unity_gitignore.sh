#!/usr/bin/env bash

gitignore=$(dirname $0)/../.gitignore

sed '/# DO NOT DELETE THE LINE: ADD YOURS BEFORE HERE/q' $gitignore | sponge $gitignore
urls="
https://raw.githubusercontent.com/github/gitignore/master/Unity.gitignore
"
for url in $urls; do
	echo >> $gitignore
	curl -s "$url" >> $gitignore
done
