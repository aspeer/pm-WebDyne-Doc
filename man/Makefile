DIR_DOCBOOK_MANP_XSL=/usr/share/sgml/docbook/xsl-stylesheets-1.75.2/manpages

WEBDYNE_DIR=/home/aspeer/Development/WebDyne/bin

all : wdcompile wdrender wddump wddebug

%.1 : %.1.xml
	xsltproc -o $@ $(DIR_DOCBOOK_MANP_XSL)/docbook.xsl $<

%.pod : %.1
	man ./$< | rman -f pod > $@
	perl -i -nle 's/^=head1 B<(.*)>/=head1 $$1/; print $$_' $@

%:	%.pod
	perl -i -nle '/^=head1/&&$$m++;print $$_ unless $$m' $(WEBDYNE_DIR)/$@
	cat $< >> $(WEBDYNE_DIR)/$@

clean : 
	rm -f *.1
	rm -f *.pod
