
DEBUG_FLAGS := -ggdb -fstack-protector-all -D_FORTIFY_SOURCE=2 -fno-strict-overflow

all: literate/bin/lit
	literate/bin/lit src/sud.lit
	@echo "C output:    sud.c"
	@echo "HTML output: sud.html"
	gcc -Wall -std=c99 -I. $(DEBUG_FLAGS) -c src/io.c
	gcc -Wall -std=c99 $(DEBUG_FLAGS) sud.c io.o -o sud

literate: literate
	make -C literate

clean:
	rm -f sud.html sud.c
