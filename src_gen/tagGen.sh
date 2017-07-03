#! /bin/bash

ctags -I __THROW --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p -R -f ~/.vim/systags /usr/include /usr/local/include
