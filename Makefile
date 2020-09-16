name = lunch
version = 20200917

prefix ?= /usr/local
bindir ?= ${prefix}/bin
datadir ?= ${prefix}/share
mandir ?= ${datadir}/man
man1dir ?= ${mandir}/man1

SHELLCHECK ?= shellcheck
SHELLSPEC ?= shellspec
MANDOC ?= mandoc

-include config.mk

BINS = \
    lunch \
    terminal

MAN1 = ${BINS:=.1}
MANS = ${MAN1}

dev: FRC all lint check
all: FRC ${BINS} ${MANS}

bin: FRC ${BINS}
man: FRC ${MANS}

.SUFFIXES:

.SUFFIXES: .in
.in:
	sed \
	    -e "s|@@name@@|${name}|g" \
	    -e "s|@@version@@|${version}|g" \
	    -e "s|@@prefix@@|${prefix}|g" \
	    -e "s|@@bindir@@|${bindir}|g" \
	    -e "s|@@mandir@@|${mandir}|g" \
	    -e "s|@@man1dir@@|${man1dir}|g" \
	    $< > $@
	chmod +x $@

.sh:
	sed \
	    -e "s|@@name@@|${name}|g" \
	    -e "s|@@version@@|${version}|g" \
	    -e "s|@@prefix@@|${prefix}|g" \
	    -e "s|@@bindir@@|${bindir}|g" \
	    -e "s|@@mandir@@|${mandir}|g" \
	    -e "s|@@man1dir@@|${man1dir}|g" \
	    $< > $@
	chmod +x "$@"

install: FRC all
	install -d \
	    ${DESTDIR}${bindir} \
	    ${DESTDIR}${mandir} \
	    ${DESTDIR}${man1dir}

	for bin in ${BINS}; do install -m0755 $${bin} ${DESTDIR}${bindir}; done
	for man1 in ${MAN1}; do install -m0644 $${man1} ${DESTDIR}${man1dir}; done

clean: FRC
	rm -f ${BINS}

lint: FRC ${BINS}
	${SHELLCHECK} ${BINS}
	${MANDOC} -T lint ${MANS}

check: FRC ${BINS}
	${SHELLSPEC} ${SHELLSPEC_FLAGS}

FRC:
