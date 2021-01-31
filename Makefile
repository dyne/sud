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

literate: literate/bin/lit
	make -C literate

install:
	install -o root -g root -p -m 4775 sud $(DESTDIR)$(PREFIX)/bin

clean:
	rm -f sud parg.o sud.html sud.c macros.h index.html
