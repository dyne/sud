PREFIX ?= /usr/local
CC ?= gcc
CFLAGS ?= -std=c99 -I src
SECURE_FLAGS := -fstack-protector-all -D_FORTIFY_SOURCE=2 -fno-strict-overflow
DEBUG_FLAGS := -ggdb -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align -Wstrict-prototypes -Wmissing-prototypes

##@ General
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' Makefile

all: debug


codegen: ## Generate C code from literate file in src/
	@echo Building SUD
	@echo
	literate/bin/lit src/sud.lit
	@sed -e '/sud.html/index.html/g' sud.html > index.html
	@rm sud.html
	@echo "C output:    sud.c"
	@echo "HTML output: index.html"
	@echo

release: codegen stamp ## Build a dynamically linked release
	${CC} $(CFLAGS) -O3 $(SECURE_FLAGS) -c src/parg.c
	${CC} $(CFLAGS) -O3 $(SECURE_FLAGS) -DRELEASE -c sud.c
	${CC} $(CFLAGS) -O3 $(SECURE_FLAGS) sud.o parg.o -o sud

debug: codegen ## Build a shared binary with debugging symbols
	${CC} $(CFLAGS) $(DEBUG_FLAGS) -c src/parg.c
	${CC} $(CFLAGS) $(DEBUG_FLAGS) sud.c parg.o -o sud
	@echo
	@echo "BEWARE this is a debug build."

install: ## Install the current build system-wide
	install -m 4755 -o root -g 0 sud $(DESTDIR)$(PREFIX)/bin/sud

clean: ## Clean the build
	rm -f sud *.o *.h *.c *.html

stamp: ## Generate a SHA512 hash and timestamp for the binary build
	@echo "#define SHA512_SUD_C \"$(shell sha512sum sud.c)\"" > stamp.h
	@echo "#define BUILD_TIME \"$(shell date)\"" >> stamp.h
	@echo
	@echo "Release stamp generated:"
	@cat stamp.h
	@echo

release-musl: codegen stamp ## Build a static release with musl
	musl-gcc $(CFLAGS) -O3 $(SECURE_FLAGS) -c src/parg.c
	musl-gcc $(CFLAGS) -O3 $(SECURE_FLAGS) -DRELEASE -c sud.c
	musl-gcc $(CFLAGS) -static -O3 $(SECURE_FLAGS) sud.o parg.o -o sud

release-osx: codegen stamp
	clang $(CFLAGS) -O3 $(SECURE_FLAGS) -c src/parg.c
	clang $(CFLAGS) -O3 $(SECURE_FLAGS) -DRELEASE -c sud.c
	clang $(CFLAGS) -O3 $(SECURE_FLAGS) sud.o parg.o -o sud

release-rpi: pi = /opt/cross-pi-gcc ## Build a static release with cross-pi
release-rpi: gcc := $(pi)/bin/arm-linux-gnueabihf-gcc
release-rpi: CFLAGS := -O3 -march=armv6 -mfloat-abi=hard -mfpu=vfp -I$(pi)/arm-linux-gnueabihf/include
release-rpi: codegen stamp
		$(gcc) $(CFLAGS) $(SECURE_FLAGS) -c src/parg.c
		$(gcc) $(CFLAGS) $(SECURE_FLAGS) -DRELEASE -c sud.c
		$(gcc) $(CFLAGS) $(SECURE_FLAGS) sud.o parg.o -o sud

release-sign: ## Sign the SHASUMS on the uploaded release
	curl https://files.dyne.org/sud/SHASUMS.txt | grep sud.c > SHASUMS_old.txt
	echo "$(shell sha512sum sud.c) $(shell grep 'define VERSION' sud.c | cut -d\" -f2)" >> SHASUMS_old.txt
	cat SHASUMS_old.txt | gpg -o SHASUMS.txt --clear-sign
