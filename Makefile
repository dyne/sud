DESTDIR ?= ""
PREFIX ?= /usr/local
SECURE_FLAGS := -fstack-protector-all -D_FORTIFY_SOURCE=2 -fno-strict-overflow
DEBUG_FLAGS := -ggdb -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align -Wstrict-prototypes -Wmissing-prototypes

all: literate/bin/lit
	pandoc -f gfm -t html README.md -o index.html
	literate/bin/lit src/sud.lit
	@echo "C output:    sud.c"
	@echo "HTML output: sud.html"
	gcc -std=c99 $(DEBUG_FLAGS) -I src -c src/parg.c
	gcc -std=c99 $(DEBUG_FLAGS) sud.c parg.o -o sud

release: stamp
	pandoc -f gfm -t html README.md -o index.html
	literate/bin/lit src/sud.lit
	musl-gcc -O3 -std=c99 $(SECURE_FLAGS) -I src -c src/parg.c
	musl-gcc -O3 -std=c99 $(SECURE_FLAGS) -DRELEASE -I src -c sud.c
	musl-gcc -static -O3 -std=c99 $(SECURE_FLAGS) sud.o parg.o -o sud
	sha512sum sud.c | gpg -o SHASUMS.txt --clear-sign

stamp:
	echo "#define SHA512_SUD_C \"$(shell sha512sum sud.c)\"" > stamp.h
	echo "#define BUILD_TIME \"$(shell date)\"" >> stamp.h

literate: literate/bin/lit
	make -C literate

install:
	install -o root -g root -p -m 4775 sud $(DESTDIR)$(PREFIX)/bin

clean:
	rm -f sud parg.o sud.html sud.c macros.h index.html
