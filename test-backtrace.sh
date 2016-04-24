#!/bin/bash

# This script is messy
# glibc:  libc_FULL_PATH=/lib/libc.so.6 libgcc_a_FULL_PATH=/usr/lib/gcc/x86_64-pc-linux-gnu/4.9.3/libgcc.a        LIBADD=/lib/libdl.so.2 make
# uclibc: libc_FULL_PATH=/lib/libc.so.0 libgcc_a_FULL_PATH=/usr/lib/gcc/x86_64-gentoo-linux-uclibc/4.9.3/libgcc.a LIBADD=/lib/libdl.so.0 make

ln -sf libubacktrace.so.0.0 libubacktrace.so
ln -sf libubacktrace.so.0.0 libubacktrace.so.0
gcc -I. -L. -o test-backtrace test-backtrace.c -lubacktrace
LD_LIBRARY_PATH=.  ./test-backtrace 10
rm -f test-backtrace
rm -f libubacktrace.so.0
rm -f libubacktrace.so
