#! /bin/bash

find . -name "include" | sed 's/^\.\///' | awk '{printf("set path+=%s\n", $1)}' >> inc.vim
find . -name "*.h" | grep -v include | xargs -i dirname {}  | sed 's/^\.\///' |sort | uniq | awk '{printf("set path+=%s\n", $1)}' >> inc.vim
