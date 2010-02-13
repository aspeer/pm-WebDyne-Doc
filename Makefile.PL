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
        COPYRIGHT			  =>  'Copyright (c) 2003 Andrew Speer, All rights reserved',
	LICENSE				  =>  'GPL: GNU General Public License'
    }


   );


sub MY::postamble {

return <<'MAKE_FRAG';

DIR_DOCBOOK=./doc
DIR_MANPAGE=./man
DIR_DOCBOOK_XSL=/usr/share/sgml/docbook/xsl-stylesheets-1.75.2

DIRS=$(DIR_DOCBOOK) $(DIR_MANPAGE)
export

webdyne_doc : 
	$(MAKE) -C $(DIR_DOCBOOK)

webdyne_man :
	cd $(DIR_MANPAGE); $(MAKE) $(MFLAGS)

all :: webdyne_doc webdyne_man

clean ::
	$(ECHO) cleaning up in .
	-for d in $(DIRS); do $(MAKE) -C $$d clean; done

MAKE_FRAG
}

