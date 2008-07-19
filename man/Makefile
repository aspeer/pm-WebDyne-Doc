DIR_DOCBOOK_MANP_XSL=/usr/share/sgml/docbook/xsl-stylesheets-1.73.2/manpages

all : wdcompile.pod wdrender.pod wddump.pod

%.1 : %.1.xml
	xsltproc -o $@ $(DIR_DOCBOOK_MANP_XSL)/docbook.xsl $<

%.pod : %.1
	man ./$< | rman -f pod > $@
	perl -i -nle 's/^=head1 B<(.*)>/=head1 $$1/; print $$_' $@

clean : 
	rm -f *.1
	rm -f *.pod
