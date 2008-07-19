#!/usr/bin/perl

use strict;
use IO::File;
use Syntax::Highlight::HTML;

#=====================================================================


#  Open file, prepare to suck in all of it at once.
#
my $fn=shift() ||
  die("Usage: $0 filename");
my $fh=IO::File->new($fn, O_RDONLY) ||
  die("unable to open file '$fn', $!");
$/=undef;


#  Create new formatter object, format and close file handle
#
my $html_or=Syntax::Highlight::HTML->new() ||
  die("unable to create Syntax::Highlight::HTML object !");
my $html=$html_or->parse(<$fh>);
$fh->close();


#  Escape brackets so not parsed by psp processor
#
$html=~s/{/&#123;/g;
$html=~s/}/&#125;/g;


#  Done, dump to screen
#
print $html;


