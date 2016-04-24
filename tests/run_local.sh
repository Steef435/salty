#!/usr/bin/sh

for t in *.js ; do
	GI_TYPELIB_PATH=../ LD_LIBRARY_PATH=../ gjs "$t" $*
done
