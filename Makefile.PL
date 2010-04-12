#  Makefile.PL for WebDyne Site
#
package WebDyne::Doc;


#  Compiler Pragma
#
use 5.006;
use strict qw(vars);


#  External Modules
#
use ExtUtils::MakeMaker;


#  All done, init finished
#
#------------------------------------------------------------------------------


#  Create the Makefile
#
WriteMakefile(

    NAME				  =>  __PACKAGE__,
    VERSION_FROM			  =>  'VERSION.pm',
    PM					  =>  {},

    'dist'				  =>  {
	COMPRESS			  =>  'gzip -9f', 
	SUFFIX				  =>  '.gz'
       },


    'depend'				  =>   {
	Makefile			  =>  '$(VERSION_FROM)'
       },


    'macro'				  =>   {
        COPYRIGHT			  =>  'Copyright (C) 2003 Andrew Speer, All rights reserved',
	LICENSE				  =>  'GPL: GNU General Public License'
    }


   );


sub MY::postamble {

return <<'MAKE_FRAG';

DIR_DOCBOOK=./doc
DIR_MANPAGE=./man
DIR_DOCBOOK_XSL=/usr/share/sgml/docbook/xsl-stylesheets-1.75.2

DIR_WEBDYNE_DEV_BIN=$(CURDIR)/../WebDyne/bin
DIR_WEBDYNE_DEV=$(CURDIR)/../WebDyne

DIR_WEBDYNE_SITE_DOC=$(CURDIR)/../WebDyne-Site/lib/WebDyne/Site/HTML/html/documentation

DIRS=$(DIR_DOCBOOK) $(DIR_MANPAGE)
export

all	:: 
	$(MAKE) -C $(DIR_DOCBOOK)
	$(MAKE) -C $(DIR_MANPAGE)

install ::
	$(MAKE) -C $(DIR_DOCBOOK) $@
	$(MAKE) -C $(DIR_MANPAGE) $@

clean	::
	$(ECHO) cleaning up in .
	-for d in $(DIRS); do $(MAKE) -C $$d clean; done

MAKE_FRAG
}

