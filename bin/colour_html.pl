#!/usr/bin/perl

use strict;
use IO::File;
use Syntax::Highlight::HTML;
use Data::Dumper;

#=====================================================================

my %WEBDYNE_TAG=map { $_=>1 } qw(
    block
    perl
    subst
    dump
    include
);

my %CGI_TAG_IMPLICIT=map { $_=>1 } qw(

    popup_menu
    textfield
    textarea
    radio_group
    password_field
    filefield
    scrolling_list
    checkbox_group
    checkbox
    hidden
    submit
    reset
    dump

);
                                                       
*Syntax::Highlight::HTML::webdyne=\%WEBDYNE_TAG;
*Syntax::Highlight::HTML::webdyne=\%CGI_TAG_IMPLICIT;

my %classes = (
    declaration   => 'h-decl',  # declaration <!DOCTYPE ...>
    process       => 'h-pi',    # process instruction <?xml ...?>
    comment       => 'h-com',   # comment <!-- ... -->
    angle_bracket => 'h-ab',    # the characters '<' and '>' as tag delimiters
    tag_name      => 'h-tag',   # the tag name of an element
    webdyne_tag_name      => 'h-webdyne_tag',   # the tag name of an element
    cgi_tag_name      => 'h-cgi_tag',   # the tag name of an element
    attr_name     => 'h-attr',  # the attribute name
    attr_value    => 'h-attv',  # the attribute value
    entity        => 'h-ent',   # any entities: &eacute; &#171;
    line_number   => 'h-lno',   # line number
);

*Syntax::Highlight::HTML::_highlight_tag=sub {

    my $self = shift;
    my $event = shift;
    my $tagname = shift;
    my $attr = shift;

    
    $_[0] =~ s|&([^;]+;)|<span class="$classes{entity}">&amp;$1</span>|g;
    
    if($event eq 'declaration' or $event eq 'process' or $event eq 'comment') {
        $_[0] =~ s/</&lt;/g;
        $_[0] =~ s/>/&gt;/g;
        $self->{output} .= qq|<span class="$classes{$event}">| . $_[0] . '</span>'
    
    } 
    else {
        if($WEBDYNE_TAG{$tagname}) {
          $_[0] =~ s|^<$tagname|<<span class="$classes{webdyne_tag_name}">$tagname</span>|;
          $_[0] =~ s|^</$tagname|</<span class="$classes{webdyne_tag_name}">$tagname</span>|;
        }
        elsif($CGI_TAG_IMPLICIT{$tagname}) {
          $_[0] =~ s|^<$tagname|<<span class="$classes{cgi_tag_name}">$tagname</span>|;
          $_[0] =~ s|^</$tagname|</<span class="$classes{cgi_tag_name}">$tagname</span>|;
        }
        elsif(($tagname=~/^start_/i) || ($tagname=~/^end_/i)) {
          $_[0] =~ s|^<$tagname|<<span class="$classes{cgi_tag_name}">$tagname</span>|;
          $_[0] =~ s|^</$tagname|</<span class="$classes{cgi_tag_name}">$tagname</span>|;
        }
        else {
          $_[0] =~ s|^<$tagname|<<span class="$classes{tag_name}">$tagname</span>|;
          $_[0] =~ s|^</$tagname|</<span class="$classes{tag_name}">$tagname</span>|;
        }        
        $_[0] =~ s|^<(/?)|<span class="$classes{angle_bracket}">&lt;$1</span>|;
        $_[0] =~ s|(/?)>$|<span class="$classes{angle_bracket}">$1&gt;</span>|;
        #$_[0] =~ s|^(!{!)|<span class="$classes{angle_bracket}">$1</span>|;
        #$_[0] =~ s|(/?)>$|<span class="$classes{angle_bracket}">$1&gt;</span>|;
        for my $attr_name (keys %$attr) {
            next if $attr_name eq '/';
            $_[0] =~ s{$attr_name=(["'])\Q$$attr{$attr_name}\E\1}
            {<span class="$classes{attr_name}">$attr_name</span>=<span class="$classes{attr_value}">$1$$attr{$attr_name}</span>$1}
        }
        
        $self->{output} .= $_[0];
    }
  
};


*Syntax::Highlight::HTML::_highlight_text=sub {
  my $self = shift;
  $_[0] =~ s|&([^;]+;)|<span class="$classes{entity}">&amp;$1</span>|g;
  $_[0] =~ s|__PERL__|&#095&#095PERL&#095&#095|g;
  $self->{output} .= $_[0];
};


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


