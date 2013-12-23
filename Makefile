#!/usr/bin/make

SHELL	 = /bin/bash

PNAME    = screenconfig
PDESC    = screenconfig - automatically sets up your display layout using udev
REPOSITORY = ispconfig.mawoh.org
REPODIR = /var/www/clients/client1/web22/web

DESTDIR ?= /
USRPREFIX  ?= /usr
VERSION  = $(shell head -n 1 VERSION)
RELEASE  = $(shell head -n 1 RELEASE)
REVISION = $(shell git log --pretty=format:'' | wc -l)
USER     = $(shell git log --format="%an <%ae>" -1)

BINDIR  = $(USRPREFIX)/bin
SBINDIR = $(USRPREFIX)/sbin
LIBDIR  = $(USRPREFIX)/lib/$(PNAME)
VARLIBDIR  = /var/lib/$(PNAME)
ETCDIR  = /etc/$(PNAME)
RULESDIR= /lib/udev/rules.d

INST_BINDIR   = $(DESTDIR)/$(BINDIR)
INST_SBINDIR  = $(DESTDIR)/$(SBINDIR)
INST_LIBDIR   = $(DESTDIR)/$(LIBDIR)
INST_VARLIBDIR= $(DESTDIR)/$(VARLIBDIR)
INST_ETCDIR   = $(DESTDIR)/$(ETCDIR)
INST_RULESDIR = $(DESTDIR)/$(RULESDIR)



help:
	@echo "do not use! it is not ready yet"
	@echo "commands that work:"
	@echo "make version		shows version of program"
	@echo "make clean		removes tmp/cache files"
	@echo "make upload		upload .deb packages to remote debian repo and update reprepo"
	@echo "make package		create debian package"


build: update-version

clean:
	rm -f *~
	rm -f *.8
	rm -f *.1
	rm -f debian/cron.d
	rm -rf itmp
	rm -rf mtmp
	rm -rf debian/$(PNAME)


test:
	@echo "no tests available"


update-doc:
	echo "no docs"

install: clean update-doc 
	@echo "installing $(PNAME) $(VERSION).$(RELEASE)-$(REVISION)"
	mkdir -p $(INST_RULESDIR)
	mkdir -p $(INST_BINDIR)
	#perl -p -i -e "s/^VERSION=noversion/VERSION='$(VERSION).$(RELEASE)-$(REVISION)'/" $(INST_SBINDIR)/screenconfig
	install -g root -o root -m 644 rules.d/99-screenconfig.rules $(INST_RULESDIR)
	install -g root -o root -m 755 bin/screenconfig $(INST_BINDIR)

package: debian-package
debian-package:
	debuild -uc -us

set-debian-release:
	dch -v "$(VERSION).$(RELEASE)-$(REVISION)" "new release"

	
increase-release:
	@cat RELEASE|perl -pe '$$_++' >RELEASE.new
	@mv RELEASE.new RELEASE
	make version

update-version-files:
	@head -n 1 debian/changelog | \
	perl -ne '/\(([\d\.]+)\.(\d+)\-(\d+)\)/ and print "$$1\n"' >VERSION
	@head -n 1 debian/changelog | \
	perl -ne '/\(([\d\.]+)\.(\d+)\-(\d+)\)/ and print "$$2\n"' >RELEASE

version: status
status:
	@echo "this is $(PNAME) $(VERSION).$(RELEASE)-$(REVISION)"

new-release:
	@echo "are you sure you want to increase the release number $(RELEASE)?"
	@echo "press ENTER to continue or C-c to abort"
	@read
	make increase-release set-debian-release update-version-files
	git commit -m "final commit before release change"
	git tag -a "$(VERSION).$(RELEASE)"	
	git push

move-packages:
	@mkdir -p ../stable ../unstable
	@(mv -v ../$(PNAME)_*.*1-*.* ../unstable 2>&1|grep -v 'cannot stat') || true
	@(mv -v ../$(PNAME)_*.*3-*.* ../unstable 2>&1|grep -v 'cannot stat') || true
	@(mv -v ../$(PNAME)_*.*5-*.* ../unstable 2>&1|grep -v 'cannot stat') || true
	@(mv -v ../$(PNAME)_*.*7-*.* ../unstable 2>&1|grep -v 'cannot stat') || true
	@(mv -v ../$(PNAME)_*.*9-*.* ../unstable 2>&1|grep -v 'cannot stat') || true
	@(mv -v ../$(PNAME)_*.* ../stable 2>&1|grep -v 'cannot stat') || true

upload: move-packages
	rsync -vP ../stable/*deb root@$(REPOSITORY):/tmp/ 
	ssh -l root $(REPOSITORY) 'cd $(REPODIR) && for f in /tmp/*deb; do reprepro includedeb squeeze $$f;done'


changelog:
	git log --data-order --date=short sed -e '/^commit.*$/d' | awk '/^Author/ {sub(/\\$/,""); getline t; print $0 t; next}; 1' | sed -e 's/^Author: //g' | sed -e 's/>Date:   \([0-9]*-[0-9]*-[0-9]*\)/>\t\1/g' | sed -e 's/^\(.*\) \(\)\t\(.*\)/\3    \1    \2/g' > CHANGELOG