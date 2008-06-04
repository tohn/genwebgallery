# genwebgallery by meillo@marmaro.de


NAME=genwebgallery
VERSION=$(shell sed -n '/VERSION=/ s/^.*=//p' $(NAME) )
NV=${NAME}-${VERSION}

DOCS=COPYRIGHT ChangeLog TODO

# paths
PREFIX = /usr/local
BINDIR = ${PREFIX}/bin
MANDIR = ${PREFIX}/share/man


all:
	@echo usage: make [un]install


dist: changelog
	@echo "generating distribution tarball"
	@mkdir ${NV}
	@cp -f ${NAME} ${NAME}.1 Makefile ${DOCS} ${NV}
	@tar -czho --owner 0 --group 0 -f ${NV}.tar.gz ${NV}
	@rm -rf ${NV}


changelog:
	@echo generating changelog from mercurial log
	@hg log -v --style changelog > ChangeLog


install:
	@echo installing executable file to ${DESTDIR}${BINDIR}
	@mkdir -p ${DESTDIR}${BINDIR}
	@cp -f ${NAME} ${DESTDIR}${BINDIR}
	@chmod 755 ${DESTDIR}${BINDIR}/${NAME}
	@echo installing manual page to ${DESTDIR}${MANDIR}/man1
	@mkdir -p ${DESTDIR}${MANDIR}/man1
	@cp -f ${NAME}.1 ${DESTDIR}${MANDIR}/man1
	@chmod 644 ${DESTDIR}${MANDIR}/man1/${NAME}.1


uninstall:
	@echo removing executable file from ${DESTDIR}${BINDIR}
	@rm -f ${DESTDIR}${BINDIR}/${NAME}
	@echo removing manual page from ${DESTDIR}${MANDIR}/man1
	@rm -f ${DESTDIR}${MANDIR}/man1/${NAME}.1


clean:
	@echo removing generated files
	@rm -f ChangeLog



.PHONY: all dist changelog clean install uninstall
