use 5.006;
use strict;
use ExtUtils::MakeMaker;
my $mm_ver=$ExtUtils::MakeMaker::VERSION;
if ($mm_ver=~/_/) {    # dev version
    $mm_ver=eval $mm_ver;
    die $@ if $@;
}
my %WriteMakefile=(
    NAME          => 'WebDyne::Doc',
    VERSION_FROM  => 'VERSION.pm',
    ABSTRACT_FROM => 'VERSION.pm',
    EXE_FILES     => do {[
        'bin/mdsplit',
    ]},
    LICENSE          => 'perl',
    AUTHOR           => 'Andrew Speer <andrew.speer@isolutions.com.au>',
    MIN_PERL_VERSION => '5.006',
    PREREQ_PM        => {
    },
    META_MERGE => {
        'meta-spec' => {
            version => 2
        },
        resources => {
            homepage   => 'https://github.com/aspeer/pm-WebDyne-Doc',
            repository => {
                type => 'git',
                url  => 'https://github.com/aspeer/pm-WebDyne-Doc.git',
                web  => 'https://github.com/aspeer/pm-WebDyne-Doc'
            }
        }
    },
    PM_FILTER => $ENV{'PM_DEBUG'} || $ENV{'WEBDYNE_DEBUG'} || do {
        use IO::File;
        my $fn='.pm_filter.pf';
        my $fh=IO::File->new($fn, O_WRONLY | O_CREAT | O_TRUNC) ||
            die("unable to write filter file '$fn', $!");
        print $fh 's/^(\s*)debug\\(/${1}0 && debug\\(/m; print';
        $fh->close();
        my $pm_filter="\$(PERL) -nl $fn";
    },
    'depend' => {
        Makefile => '$(VERSION_FROM)',
    },
    'dist' => {
        COMPRESS => 'gzip -9f',
        SUFFIX   => '.gz'
    },
);
my %MM_Compat=(
    '5.46'   => [q(PM_FILTER)],
    '6.31'   => [q(LICENSE)],
    '6.46'   => [q(META_MERGE)],
    '6.48'   => [q(MIN_PERL_VERSION)],
    '6.52'   => [q(CONFIGURE_REQUIRES)],
    '6.5503' => [q(BUILD_REQUIRES)],
    '6.64'   => [q(TEST_REQUIRES)],
);
while (my ($mm_ver_test, $ar)=each %MM_Compat) {
    if (version->parse($mm_ver) < version->parse($mm_ver_test)) {
        delete @WriteMakefile{@{$ar}};
    }
}
WriteMakefile(%WriteMakefile);


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

#md ::
#    pandoc -f docbook -t gfm --lua-filter=bin/admonition.lua -o md/webdyne.md doc/webdyne.xml

md_split :: 
	$(PERL) bin/md_split_sections.pl doc/webdyne.md
    
mkdocs ::
	mkdocs build -f ./mkdocs.yml --clean 

mkdocs_serve ::
	mkdocs serve

clean	::
	$(ECHO) cleaning up in .
	-for d in $(DIRS); do $(MAKE) -C $$d clean; done

MAKE_FRAG
}

__END__



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
