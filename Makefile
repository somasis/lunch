name = lunch
version = 20210120

prefix ?= /usr/local
bindir ?= ${prefix}/bin
datadir ?= ${prefix}/share
mandir ?= ${datadir}/man
man1dir ?= ${mandir}/man1
sysconfdir ?= ${prefix}/etc

SHELLCHECK ?= shellcheck
MANDOC ?= mandoc

-include config.mk

BINS = \
    exo-open \
    lunch \
    terminal

MAN1 = ${BINS:=.1}
MANS = ${MAN1}

dev: FRC README all lint
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

README: lunch.1
	man ./$< | col -xb > $@

clean: FRC
	rm -f ${BINS}

lint: FRC ${BINS}
	${SHELLCHECK} ${BINS}
	${MANDOC} -T lint -W style ${MANS}

install-contrib: FRC
	install -d \
	    ${DESTDIR}${datadir}/applications \
	    ${DESTDIR}${sysconfdir}

	install -m0644 contrib/lunch.desktop ${DESTDIR}${datadir}/applications
	install -m0644 contrib/mailcap ${DESTDIR}${sysconfdir}/mailcap

FRC:
