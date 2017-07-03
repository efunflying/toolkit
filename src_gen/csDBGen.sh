#! /bin/bash

cd $1

if [ !$1 ]; then
	dir=`dirname $0`
	cd $dir
fi

rm -f tags
ctags -R .

find . -type f | grep -v "tags" | grep -iE "(Makefile)|(\.((h)|(c)|(cc)|(cpp)|(ini)|(xml)|(sql)|(conf)|(asm)|(hpp)|(src))$)" > cscope.files
cscope -bq
