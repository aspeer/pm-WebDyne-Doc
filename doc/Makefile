DIR_LDP=../ldp
#DIR_DOCBOOK_XSL_HTML=$(DIR_DOCBOOK_XSL)/html
DIR_DOCBOOK_DSL=$(DIR_LDP)/ldp-custom.dsl
DIR_DOCBOOK_DCL=/usr/share/doc/HTML/en/common/xml.dcl
DIR_EXAMPLE=./example

.SUFFIXES : .psp .html 

.psp.html :
	#perl ../bin/colour_html.pl $< > $@
	cp $< $@
	
webdyne_examples := $(patsubst %.psp,%.html,$(wildcard $(DIR_EXAMPLE)/*.psp))

all	:	webdyne.pdf

#webdyne.psp : webdyne.xml $(webdyne_examples)
#	-openjade -t xml -i html -d $(DIR_DOCBOOK_DSL)#html -V nochunks $(DIR_DOCBOOK_DCL) $< > $@
#	perl -pi -e 's/#include \"(.*)\"/qx[cat $$1]/e' $@
#	perl -pi -e 's/__PERL__/&#095&#095PERL&#095&#095/g' $@
#	perl -pi -e 's/\!{\!(.*?)\!}/&#033{&#033$1&#033}/g' $@
#	perl -pi -e 's/\@{(.*?)}/&#064{$$1}/g' $@
#	perl -pi -e 's/\%{(.*?)}/&#037{$$1}/g' $@
#	perl -pi -e 's/\+{(.*?)}/&#043{$$1}/g' $@
#	perl -pi -e 's/\*{(.*?)}/&#042{$$1}/g' $@
#	perl -pi -e 's/\^{(.*?)}/&#094{$$1}/g' $@

##webdyne.html : webdyne.psp
#	perl /opt/webdyne/bin/wdrender $< > $@
#	wdrender $< > $@
#	perl -pi -e 's/&#095/_/g' $@
#	perl -pi -e 's/&#033/!/g' $@
#	perl -pi -e 's/&#064/@/g' $@
#	perl -pi -e 's/&#037/%/g' $@
#	perl -pi -e 's/&#043/+/g' $@
#	perl -pi -e 's/&#042/*/g' $@
#	perl -pi -e 's/&#094/^/g' $@
	
#webdyne.pdf : webdyne.html
#	htmldoc -f webdyne.pdf webdyne.html

webdyne.md : webdyne.xml
	#pandoc webdyne.xml -f docbook -t markdown -o webdyne.md
	pandoc -f docbook -t gfm --lua-filter=admonition-advanced.lua -o webdyne.md webdyne.xml
	perl -pi -e 's/^\s*#include \"(.*)\"/"```html\n".qx[cat $$1]."\n```"/e' $@
	perl -pi -e 's/\\</</g' $@
	#perl -pi -e 's/__PERL__/&#095&#095PERL&#095&#095/g' $@
	#perl -pi -e 's/\!{\!(.*?)\!}/&#033{&#033{$$1}&#033}/g' $@
	#perl -pi -e 's/\@{(.*?)}/&#064{$$1}/g' $@
	#perl -pi -e 's/\%{(.*?)}/&#037{$$1}/g' $@
	#perl -pi -e 's/\+{(.*?)}/&#043{$$1}/g' $@
	#perl -pi -e 's/\*{(.*?)}/&#042{$$1}/g' $@
	#perl -pi -e 's/\^{(.*?)}/&#094{$$1}/g' $@

clean	: 
	rm -f webdyne.psp webdyne.html $(DIR_EXAMPLE)/*.html

install :: webdyne.pdf
	cp -R * $(DIR_WEBDYNE_SITE_DOC)
	cp webdyne.pdf $(DIR_WEBDYNE_DEV)/doc
	
