CC:=gcc
CFLAGS:=
LDFLAGS:=
PREFIX:=/usr/local
INSTALL:=(cp $1 $2 && chmod $3 $2/$1)

EXTRA_CFLAGS:=-DCOVERITY
LDOBJS:=-lbz2

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
	bsdiff bsdiff bspatch patch
	bspatch bsdiff bspatch.2 patch
	diff bspatch bspatch.2
	rm patch bspatch.2

clean:
	-rm *.o bsdiff bspatch patch bspatch.2

