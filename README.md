# SUD :: Super User Do

This software aims to be a UNIX tool for generic secure usage when in
need of privilege escalation. It is designed to run SUID, with
"super-user powers" to execute things as root on the system it is
installed.

## Methodology

SUD is designed for security: it leverages all possible measures to
avoid vulnerabilities, primarily the reduction of complexity in its
own design and implementation.

SUD is software written following the
[literate-programming](https://en.wikipedia.org/wiki/Literate_programming)
approach and welcomes reviews and contributions, also anonymous ones.

You are welcome to read [SUD's source-code and documentation](https://sud.dyne.org/sud.html).

SUD is licensed as Public Domain in the hope to improve the security
of UNIX systems at large. The portability of `sud` to any BSD and
POSIX compliant system is a desirable feature and contributions are
welcome.

## Downloads

SUD is distributed as a static binary for various platforms on [files.dyne.org/sud](https://files.dyne.org/sud)

Binaries include [musl-libc](https://musl-libc.org) as a statically linked component.

## Motivation

This software is a direct response to the `sudo` tool which has been
adopted by major Linux and BSD distros while augmenting its complexity
and [collecting
vulnerabilities](https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=sudo)
last not least
[CVE-2021-3156](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-3156)
which prompted the creation of `sud` to finally act up and develop
something different, considering we have been relying for 10 years on
something that could have been trivially hacked all that time.

SUD takes inspiration from the suckless tool
[sup](https://sup.dyne.org) and welcomes contributions from coders who
are well incline to be suckless.

## Work in progress

If you are watching this repo right now it means you are really
interested in the topic or have been contacted by one of us. In case
you are interested in contributing please signal yourself with an
issue and a link to anything interesting that can entertain the merry
folks gathering around this campfire.

## How to build SUD from source

Literate programming source-code starts from documentation which is
then used to generate code and a website. In case of SUD we use the
[Literate Programming System](https://github.com/zyedidia/Literate)
written in D, which is included as a submodule in the `literate`
sub-folder. To make sure it is ready for use:

1. install `dub` the D package registry on your system
2. make sure the `literate` git submodule is initialised and updated
3. enter `literate` and type `make`

## License

SUD is designed and written by Denis Roio <Jaromil @ dyne.org>

SUD is Copyright (C) 2021 by the Dyne.org foundation

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
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
