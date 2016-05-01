#!/bin/bash

ln -sf libubacktrace.so.0.0 libubacktrace.so
ln -sf libubacktrace.so.0.0 libubacktrace.so.0
gcc -I. -L. -lubacktrace test-backtrace.c -o test-backtrace -rdynamic -fasynchronous-unwind-tables
LD_LIBRARY_PATH=.  ./test-backtrace 10
rm -f test-backtrace
rm -f libubacktrace.so.0
rm -f libubacktrace.so
