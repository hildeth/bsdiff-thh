CC:=gcc
CFLAGS:=
LDFLAGS:=
PREFIX:=/usr/local
INSTALL=(cp $1 $2 && chmod $3 $2/$1)

EXTRA_CFLAGS:=-DCOVERITY
LDOBJS:=-lbz2
ifneq ($(filter mingw mingw64,$(PLATFORM)),)
EXE:=.exe
else
EXE:=
endif

all:		bsdiff bspatch test

bsdiff:		bsdiff.o err-stub.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LDOBJS)

bspatch:	bspatch.o err-stub.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LDOBJS)

.c.o:
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) -c -o $@ $<

install:
	mkdir -p $(PREFIX)/bin
	$(call INSTALL,bsdiff,$(PREFIX)/bin,555)
	$(call INSTALL,bspatch,$(PREFIX)/bin,555)
ifndef WITHOUT_MAN
	$(call INSTALL,bsdiff.1,$(PREFIX)/man/man1,444)
	$(call INSTALL,bspatch.1,$(PREFIX)/man/man1,444)
endif

test: bsdiff bspatch
	./bsdiff bsdiff$(EXE) bspatch$(EXE) patch
	./bspatch bsdiff$(EXE) bspatch.2$(EXE) patch
	diff bspatch$(EXE) bspatch.2$(EXE)
	stat -c%a bspatch > bspatch.stat
	stat -c%a bspatch.2 > bspatch.2.stat
	diff bspatch.stat bspatch.2.stat
	rm patch bspatch.2$(EXE) *.stat

clean:
	-rm *.o bsdiff bspatch patch bspatch.2$(EXE) *.stat

