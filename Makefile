# genwebgallery by meillo@marmaro.de


NAME=genwebgallery
VERSION = 0.4
NV=${NAME}-${VERSION}

DOCS=COPYRIGHT ChangeLog TODO
 
# paths 
PREFIX = /usr
BINDIR = ${PREFIX}/bin
MANDIR = ${PREFIX}/share/man

all:
	@echo usage: make [un]install

build:
	@echo build unneeded

dist: changelog
	@mkdir ${NV}
	@cp -f ${NAME} ${NAME}.1 Makefile ${DOCS} ${NV}
	@tar -czhof ${NV}.tar.gz ${NV}
	@rm -rf ${NV}

deb: dist
	@mkdir -p Packages
	@cp ${NV}.tar.gz Packages/
	@( \
		cd Packages/ ;\
		tar -xzf ${NV}.tar.gz ;\
		mv ${NV}.tar.gz ${NAME}_${VERSION}.orig.tar.gz ;\
		cd ${NV}/ ;\
		cp -r ../../debian/ . ;\
		debuild ;\
	 )

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
	@sed 's/VERSION/${VERSION}/g' < ${NAME}.1 > ${DESTDIR}${MANDIR}/man1/${NAME}.1
	@chmod 644 ${DESTDIR}${MANDIR}/man1/${NAME}.1

uninstall:
	@echo removing executable file from ${DESTDIR}${BINDIR}
	@rm -f ${DESTDIR}${BINDIR}/${NAME}
	@echo removing manual page from ${DESTDIR}${MANDIR}/man1
	@rm -f ${DESTDIR}${MANDIR}/man1/${NAME}.1

clean:
	@echo clean unneeded

distclean: clean
	@rm -f ${NAME}-*.tar.gz ChangeLog

debclean: distclean
	@cd Packages/${NV}/ ; debuild clean ;


.PHONY: all dist deb changelog clean distclean debclean build install uninstall
