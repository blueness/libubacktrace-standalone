# Makefile for uClibc (libubacktrace)
#
# Copyright (C) 2010 STMicroelectronics Ltd
# Author: Carmelo Amoroso <carmelo.amoroso@st.com>
#
# Licensed under the LGPL v2.1, see the file COPYING.LIB in this tarball.
#
#
# Based on uClibc/libubacktrace/Makefile.in
#
# Copyright (C) 2016 Gentoo Foundation
# Author: Anthony G. basile
# - reworked to build standalone.
#
ABI_VERSION             ?= 0
VERSION                 ?= $(ABI_VERSION).0
libubacktrace_SO        ?= libubacktrace.so
libubacktrace_SONAME    ?= $(libubacktrace_SO).$(ABI_VERSION)
libubacktrace_FULL_NAME ?= $(libubacktrace_SO).$(VERSION)
libgcc_a_FULL_PATH      ?= $(shell gcc -print-file-name=libgcc.a)
INCLUDE                 ?= /usr/include
PREFIX                  ?=
LIBADD                  ?= -lc -ldl

CC         = $(CROSS_COMPILE)gcc
STRIP      = $(CROSS_COMPILE)strip -x -R .note -R .comment
INSTALL    = install
LN         = ln -sf
RM         = rm -f

# -fasynchronous-unwind-tables is required for backtrace to work using dwarf2
CPPFLAGS += -D_GNU_SOURCE -DLIBGCC_S_SO=\"libgcc_s.so.1\" -I.
CFLAGS += -Wall -Wstrict-prototypes -Wstrict-aliasing -fstrict-aliasing \
	-funsigned-char -fno-builtin -fno-asm -std=gnu99 -fstack-protector-all \
	-fasynchronous-unwind-tables -fPIC
LDFLAGS += -Wl,-EL -shared -Wl,--warn-common -Wl,--warn-once -Wl,-z,combreloc \
	-Wl,-z,relro -Wl,-z,now -Wl,--hash-style=gnu -Wl,-O2 -Wl,-z,defs -Wl,-s

libubacktrace_HDRS := execinfo.h
libubacktrace_SRCS := backtracesyms.c backtracesymsfd.c backtrace.c
libubacktrace_OBJS := $(patsubst %.c,%.o,$(libubacktrace_SRCS))

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $^ -o $@

$(libubacktrace_FULL_NAME): $(libubacktrace_OBJS) $(libgcc_a_FULL_PATH)
	$(CC) $(LDFLAGS) -Wl,-soname=$(libubacktrace_SONAME) -nostdlib -nostartfiles -o $(libubacktrace_FULL_NAME) $^ $(LIBADD)
	strip -x -R .note -R .comment $(libubacktrace_FULL_NAME)

.PHONY : all
all: $(libubacktrace_FULL_NAME)

.PHONY : install
install: $(libubacktrace_FULL_NAME)
	$(INSTALL) $(libubacktrace_FULL_NAME) $(PREFIX)/lib
	$(LN) $(libubacktrace_FULL_NAME) $(PREFIX)/lib/$(libubacktrace_SONAME)
	$(LN) $(libubacktrace_FULL_NAME) $(PREFIX)/lib/$(libubacktrace_SO)
	$(INSTALL) -m 644 $(libubacktrace_HDRS) $(INCLUDE)

.PHONY : remove
remove:
	$(RM) $(PREFIX)/lib/$(libubacktrace_FULL_NAME)
	$(RM) $(PREFIX)/lib/$(libubacktrace_SONAME)
	$(RM) $(PREFIX)/lib/$(libubacktrace_SO)
	$(RM) $(INCLUDE)/$(libubacktrace_HDRS)

.PHONY : clean
clean:
	$(RM) *.o $(libubacktrace_SO) $(libubacktrace_SONAME) $(libubacktrace_FULL_NAME)
