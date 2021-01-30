
DEBUG_FLAGS := -ggdb -fstack-protector-all -D_FORTIFY_SOURCE=2 -fno-strict-overflow

all: literate/bin/lit
	pandoc -f gfm -t html README.md -o index.html
	literate/bin/lit src/sud.lit
	@echo "C output:    sud.c"
	@echo "HTML output: sud.html"
	gcc -Wall -std=c99 $(DEBUG_FLAGS) sud.c -o sud

literate: literate/bin/lit
	make -C literate

clean:
	rm -f sud.html sud.c
