# libubacktrace-standalone

Standalone library for backtrace.

From `man 3 backtrace`:  backtrace()  returns  a  backtrace  for the calling
program, in the array pointed to by buffer.  A backtrace is the series of
currently active function calls for the program.  Each item in the array pointed
to by buffer is of type void *, and is the return address from the corresponding
stack frame.  The size argument specifies the  maximum  number of  addresses
that  can  be stored in buffer.  If the backtrace is larger than size, then the
addresses corresponding to the size most recent function calls are returned; to
obtain the complete backtrace, make sure that buffer and size are large enough.

Maintainer: Anthony G. Basile <blueness@gentoo.org>
