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


#  Get MakeMaker version - from Test::Simple Makefile.PL
#
my $mm_ver=$ExtUtils::MakeMaker::VERSION;
if ($mm_ver=~/_/) {    # dev version
    $mm_ver=eval $mm_ver;
    die $@ if $@;
}
print "mm_ver $mm_ver, \$] $]\n";

#  All done, init finished
#
#------------------------------------------------------------------------------


#  Create the Makefile
#
WriteMakefile(

    NAME         => __PACKAGE__,
    VERSION_FROM => 'VERSION.pm',
    PM           => {},

    'dist' => {
        COMPRESS => 'gzip -9f',
        SUFFIX   => '.gz'
    },


    'depend' => {
        Makefile => '$(VERSION_FROM)'
    },


    'macro' => {
        COPYRIGHT => 'Copyright (C) 2003 Andrew Speer, All rights reserved',
        LICENSE   => 'GPL: GNU General Public License'
    },

    (
        $] < 5.005 ? () : (

            AUTHOR => 'Andrew Speer <andrew@webdyne.org>',

        )
    ),

    (
        $mm_ver < 6.31 ? () : (

            LICENSE => 'gpl',

        )
    ),

    (
        $mm_ver <= 6.45 ? () : (

            META_MERGE => {
                resources => {

                    homepage => 'http://webdyne.org',
                    license  => 'http://www.gnu.org/licenses/gpl.html'

                }}
        )
    ),


);


sub MY::postamble {

    return <<'MAKE_FRAG';

DIR_DOCBOOK=./doc
DIR_MANPAGE=./man
DIR_DOCBOOK_XSL=/usr/share/sgml/docbook/xsl-stylesheets-1.75.2

DIR_WEBDYNE_DEV_BIN=$(CURDIR)/../pm-WebDyne/bin
DIR_WEBDYNE_DEV=$(CURDIR)/../pm-WebDyne

DIR_WEBDYNE_SITE_DOC=$(CURDIR)/../pm-WebDyne-Site/lib/WebDyne/Site/HTML/html/documentation

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
