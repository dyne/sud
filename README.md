# SUD :: Super User Do

This software aims to be a UNIX tool for generic secure usage when in
need of privilege escalation. It is designed to run SUID, with
"super-user powers" to execute things as root on the system it is
installed.

[![software by Dyne.org](https://files.dyne.org/software_by_dyne.png)](http://www.dyne.org)

Main differences compared to sudo:

- Easier audit thanks to literate development methodology
- Fewer lines of code, fewer features, fewer dependencies
- No configuration file, no parsers
- Public domain licensing

SUD can either be built as a static executable (no dynamic linking of libraries)
or dynamically linked to allow PAM authentication module to do its work
by asking users to confirm their password.

It doesn't covers all use-cases addressed by sudo, but a few common
situations in which multi-user privilege isolation is a necessary and
sufficient condition to safely operate a local or remote machine.

## Methodology

SUD is designed for security: it leverages all possible measures to
avoid vulnerabilities, primarily the reduction of complexity in its
own design and implementation.

SUD is software written following the
[literate-programming](https://en.wikipedia.org/wiki/Literate_programming)
approach and welcomes reviews and contributions.

You are welcome to read [SUD's source-code and documentation](https://sud.dyne.org).

Contribute via [issues](dyne/sud/issues) or by [sending me a private email](https://jaromil.dyne.org).

SUD is licensed as Public Domain in the hope to improve the security
of UNIX systems at large. The portability of `sud` to any BSD and
POSIX compliant system is a desirable feature and contributions are
welcome.

## Downloads

SUD is distributed as a static binary for various platforms on
[files.dyne.org/sud](https://files.dyne.org/sud)

Binaries include [musl-libc](https://musl-libc.org) as a statically
linked component.

To start using sud on a 64bit GNU+Linux machine, simply do:

```
curl https://files.dyne.org/sud/sud-x86-musl > ~/Downloads/sud
```

Or on Apple/OSX:
```
curl https://files.dyne.org/sud/sud-x86-osx > ~/Downloads/sud
```

Or on a RaspberryPI (any version)
```
curl https://files.dyne.org/sud/sud-arm-rpi > ~/Downloads/sud
```

Then to activate it must be in the path and made SUID:
```
sudo install -m 4755 -o root -g 0 ~/Downloads/sud /usr/local/bin/sud
```

Use `vigr` or edit `/etc/group` to make sure your privileged users are in the `admin`, `wheel` or `sudo` groups.

To verify the binary integrity of SUD use `sud -v` and compare the SHA512 to the [hash published here](https://files.dyne.org/sud/SHASUMS.txt) and signed with [my gpg key](https://jaromil.dyne.org/jaromil.pub): it ties the binary to the `sud.c` sourcecode used to build it. Here a shell snippet that does just that:

```
hash=https://files.dyne.org/sud/SHASUMS.txt
echo "Checking sud binary integrity from: $hash\n"
curl -s https://jaromil.dyne.org/jaromil.pub | gpg --import
curl -s $hash | gpg --verify
echo "\nReleases listed:"
curl -s $hash | awk '/sud.c/ {print $0}'
echo "\nYours found at $(which sud):"
sud -v | awk '/sud.c/ {print $0}'
```

## Motivation

This software is a direct response to the `sudo` tool which has been
adopted by major Linux and BSD distros while augmenting its complexity
and [collecting
vulnerabilities](https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=sudo)
last not least
[CVE-2021-3156](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-3156).

With SUD I intend to finally act up and develop something different,
considering we have been [relying for 10 years on a tool that could
have been trivially hacked all that
time](https://www.zdnet.com/article/10-years-old-sudo-bug-lets-linux-users-gain-root-level-access/). In
doing so I do not intend to cover all use-cases addressed by `sudo`
and its plugins, but only the most common one of allowing a specific
user to execute commands as root or as another user.

SUD takes inspiration from the suckless tool
[sup](https://sup.dyne.org) and welcomes contributions from coders who
are well incline to be suckless.

SUD will never, ever include integrations with systemd.


## How to build SUD from source

Literate programming source-code starts from documentation which is
then used to generate the source-code and a website. In case of SUD
I'm using the [Literate Programming
System](https://github.com/zyedidia/Literate) written in D, which is
included as a submodule in the `literate` sub-folder. To make sure it is ready for use:

1. install `gcc` or another C compiler
2. install `dub` the D package registry and a D compiler
3. make sure the `literate` git submodule is updated and built
4. type `make` or read the `Makefile` for other targets

All the above should be possible on any operating system, if you don't
know why is most likely because you don't know well enough the system
you are running. Go find out.

## Work in progress

If you are reading down to here it means you are really
interested. Please signal yourself and be
welcome to entertain the merry folks gathering around this campfire,
there is always room for improvement.

## License

SUD is designed and written by Denis Roio <Jaromil @ dyne.org>.

SUD redistributes the [parg](https://github.com/jibsen/parg) library by Jørgen Ibsen.

Code reviews were kindly contributed by members of the Veteran Unix Admins and the 2600 Hacker Quarterly online communities.

SUD is Copyright (C) 2021 by the Dyne.org foundation

<p xmlns:dct="https://purl.org/dc/terms/" xmlns:vcard="https://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="https://creativecommons.org/publicdomain/zero/1.0/">
    <img src="https://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="https://dyne.org">
    <span property="dct:title">Dyne.org foundation</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">sud</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="NL" about="https://dyne.org">
  The Netherlands</span>.
</p>
