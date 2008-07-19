DIR_LDP=../ldp
DIR_DOCBOOK_HTML_XSL=/usr/share/sgml/docbook/xsl-stylesheets-1.73.2/html
DIR_DOCBOOK_DSL=$(DIR_LDP)/ldp-custom.dsl
DIR_DOCBOOK_DCL=/usr/share/doc/HTML/en/common/xml.dcl
DIR_EXAMPLE=./example

.SUFFIXES : .psp .html 

.psp.html :
	perl ../bin/colour_html.pl $< > $@
	
webdyne_examples := $(patsubst %.psp,%.html,$(wildcard $(DIR_EXAMPLE)/*.psp))

all : webdyne.html 

webdyne.psp : webdyne.xml $(webdyne_examples)
	openjade -t xml -i html -d $(DIR_DOCBOOK_DSL)#html -V nochunks $(DIR_DOCBOOK_DCL) $< > $@
	perl -pi -e 's/#include \"(.*)\"/qx[cat $$1]/e' $@

webdyne.html : webdyne.psp
	perl /opt/webdyne/bin/wdrender $< > $@

clean : 
	rm -f webdyne.psp webdyne.html $(DIR_EXAMPLE)/*.html
