PREFIX ?= /usr/local
CFLAGS ?= -std=c99 -I src
SECURE_FLAGS := -fstack-protector-all -D_FORTIFY_SOURCE=2 -fno-strict-overflow
DEBUG_FLAGS := -ggdb -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align -Wstrict-prototypes -Wmissing-prototypes

# default target is for debugging
debug: codegen
	gcc $(CFLAGS) $(DEBUG_FLAGS) -c src/parg.c
	gcc $(CFLAGS) $(DEBUG_FLAGS) sud.c parg.o -o sud
	@echo
	@echo "BEWARE this is a debug build."

codegen:
	@echo Building SUD
	@echo
	literate/bin/lit src/sud.lit
	@mv sud.html index.html
	@echo "C output:    sud.c"
	@echo "HTML output: index.html"
	@echo

debug-pam: codegen
	gcc $(CFLAGS) $(DEBUG_FLAGS) -c src/parg.c
	gcc $(CGLAGS) $(DEBUG_FLAGS) -DPAM_AUTH sud.c parg.o -o sud -lpam

stamp:
	@echo "#define SHA512_SUD_C \"$(shell sha512sum sud.c)\"" > stamp.h
	@echo "#define BUILD_TIME \"$(shell date)\"" >> stamp.h
	@echo
	@echo "Release stamp generated:"
	@cat stamp.h
	@echo

release-musl: codegen stamp
	musl-gcc $(CFLAGS) -O3 $(SECURE_FLAGS) -c src/parg.c
	musl-gcc $(CFLAGS) -O3 $(SECURE_FLAGS) -DRELEASE -c sud.c
	musl-gcc $(CFLAGS) -static -O3 $(SECURE_FLAGS) sud.o parg.o -o sud

release-pam: codegen stamp
	gcc $(CFLAGS) -O3 $(SECURE_FLAGS) -c src/parg.c
	gcc $(CFLAGS) -O3 $(SECURE_FLAGS) -DRELEASE -DPAM_AUTH -c sud.c
	gcc $(CFLAGS) -O3 $(SECURE_FLAGS) sud.o parg.o -o sud -lpam

release-sign:
	curl https://files.dyne.org/sud/SHASUMS.txt | grep sud.c > SHASUMS_old.txt
	echo "$(shell sha512sum sud.c) $(shell grep 'define VERSION' sud.c | cut -d\" -f2)" >> SHASUMS_old.txt
	cat SHASUMS_old.txt | gpg -o SHASUMS.txt --clear-sign

install:
	install -m 4755 -o root -g 0 sud $(DESTDIR)$(PREFIX)/bin/sud

clean:
	rm -f sud *.o *.h *.c *.html
