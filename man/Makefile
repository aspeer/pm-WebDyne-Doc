#DIR_DOCBOOK_XSL=/usr/share/sgml/docbook/xsl-stylesheets-1.75.2
DIR_DOCBOOK_XSL_MANP=$(DIR_DOCBOOK_XSL)/manpages

MAN1 = wdcompile.pod wdrender.pod wddump.pod wddebug.pod wdapacheinit.pod
MAN3 = WebDyne.pod

$(MAN1:.pod=) :

all	: $(MAN1) $(MAN3)
#all : wdcompile wdrender wddump wddebug wdapacheinit WebDyne


#%   : %.1.xml
#	xsltproc -o $@ $(DIR_DOCBOOK_XSL_MANP)/docbook.xsl $<

%.1	: %.1.xml
	xsltproc $(DIR_DOCBOOK_XSL_MANP)/docbook.xsl $<
	
%.3	: %.3.xml
	xsltproc $(DIR_DOCBOOK_XSL_MANP)/docbook.xsl $<
	
%.pod 	: %.1
	man ./$< | rman -f pod > $@
	perl -i -nle 's/^=head1 B<(.*)>/=head1 $$1/; print $$_' $@

%.pod 	: %.3
	man ./$< | rman -f pod > $@
	perl -i -nle 's/^=head1 B<(.*)>/=head1 $$1/; print $$_' $@

install :: all

install	:: $(MAN1:.pod=)
	for f in $?; do \
	perl -i -nle '/^=head1/&&$$m++;print $$_ unless $$m' $(DIR_WEBDYNE_DEV_BIN)/$$f; \
	cat $$f.pod >> $(DIR_WEBDYNE_DEV_BIN)/$$f \
	; done

install	::
	$(CP) WebDyne.3 $(DIR_WEBDYNE_DEV)/man/WebDyne.3pm
	

#install :: $(POD1)
#	-echp perl -i -nle '/^=head1/&&$$m++;print $$_ unless $$m' $(DIR_WEBDYNE_DEV_BIN)/$<; \
#	-echo cat $<.pod >> $(DIR_WEBDYNE_DEV_BIN)/$< \


#%   : %.3.xml
#	xsltproc -o $@ $(DIR_DOCBOOK_XSL_MANP)/docbook.xsl $<


webdyne_man_install :: ($POD1)
	-for f in wdcompile wdrender wddump wddebug wdapacheinit; do \
		-ecoo perl -i -nle '/^=head1/&&$$m++;print $$_ unless $$m' $(DIR_WEBDYNE_DEV_BIN)/$$f; \
		cat $$f.pod >> $(DIR_WEBDYNE_DEV_BIN)/$$f \
	;done
	
	
#webdyne_man_install :: WebDyne
#	$(CP) *.3 $(DIR_WEBDYNE_DEV)/man

#clean : 
#	rm -f *.1
#	rm -f *.3
