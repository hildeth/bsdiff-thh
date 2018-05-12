# Copyright (C) 2018 Synopsys, Inc. All rights reserved worldwide.
# 
# This file is part of bsdiff-thh, a branch of bsdiff.
# It is distributed by permission of the original author, but without endorsement.
# The Synopsys copyright reaffirms the original author''s copyright, included here verbatim:
#-
# Copyright 2003-2005 Colin Percival
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted providing that the following conditions 
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

CC:=gcc
CFLAGS:=
LDFLAGS:=
PREFIX:=/usr/local
INSTALL=(cp $1 $2 && chmod $3 $2/$1)

LDOBJS:=-lbz2
EXE:=$(findstring .EXE,$(PATHEXT))

all:		bsdiff bspatch test

bsdiff:		bsdiff.o err-stub.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LDOBJS)

bspatch:	bspatch.o err-stub.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LDOBJS)

.c.o:
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) -c -o $@ $<

install:
	mkdir -p $(PREFIX)/bin
	$(call INSTALL,bsdiff,$(PREFIX)/bin,755)
	$(call INSTALL,bspatch,$(PREFIX)/bin,755)
ifndef WITHOUT_MAN
	$(call INSTALL,bsdiff.1,$(PREFIX)/man/man1,644)
	$(call INSTALL,bspatch.1,$(PREFIX)/man/man1,644)
endif

test: bsdiff bspatch
	./bsdiff bsdiff$(EXE) bspatch$(EXE) patch
	./bspatch bsdiff$(EXE) bspatch.2$(EXE) patch
	diff bspatch$(EXE) bspatch.2$(EXE)
	stat -c%a bspatch$(EXE) > bspatch.stat
	stat -c%a bspatch.2$(EXE) > bspatch.2.stat
	diff bspatch.stat bspatch.2.stat
	rm patch bspatch.2$(EXE) *.stat

clean:
	-rm *.o bsdiff bspatch patch bspatch.2$(EXE) *.stat

