package App::Pod2Epub;

###############################################################################
#
# App::Pod2Epub - Convert Pod to an ePub eBook.
#
#
# Copyright 2010, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

use strict;
use warnings;
use Pod::Simple::XHTML;

use vars qw(@ISA $VERSION);

@ISA     = 'Pod::Simple::XHTML';
$VERSION = '0.04';

###############################################################################
#
# new()
#
# Simple constructor inheriting from Pod::Simple::XHTML.
#
sub new {

    my $class = shift;
    my $self  = Pod::Simple::XHTML->new( @_ );

    # Don't generate an XHTML index. We will use the ePub TOC instead.
    $self->index(0);

    # Add the default XHTML headers.
    $self->html_header(

        qq{<?xml version="1.0" encoding="UTF-8"?>\n}
          . qq{<!DOCTYPE html\n}
          . qq{     PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"\n}
          . qq{    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\n}
          . qq{\n}
          . qq{<html xmlns="http://www.w3.org/1999/xhtml">\n}
          . qq{<head>\n}
          . qq{<title></title>\n}
          . qq{<meta http-equiv="Content-Type" }
          . qq{content="text/html; charset=iso-8859-1"/>\n}
          . qq{<link rel="stylesheet" href="../styles/style.css" }
          . qq{type="text/css"/>\n}
          . qq{</head>\n}
          . qq{\n}
          . qq{<body>\n}
    );


    bless $self, $class;
    return $self;
}

###############################################################################
#
# start_L()
#
# Override the Pod::Simple::XHTML/Methody function that deal with the start
# of Pod L<> links in order to encode XML entities in a href url. The text of
# href is already entity encoded by the parent module.
#
sub start_L {

    # The main code is taken from Pod::Simple::XHTML.
    my ( $self, $flags ) = @_;
    my ( $type, $to, $section ) = @{$flags}{ 'type', 'to', 'section' };
    my $url =
        $type eq 'url' ? $to
      : $type eq 'pod' ? $self->resolve_pod_page_link( $to, $section )
      : $type eq 'man' ? $self->resolve_man_page_link( $to, $section )
      :                  undef;

    # This is the new/overridden section.
    if ( defined $url ) {
        $url = Pod::Simple::XHTML::encode_entities( $url );
    }

    # If it's an unknown type, use an attribute-less <a> like HTML.pm.
    $self->{'scratch'} .= '<a' . ( $url ? ' href="' . $url . '">' : '>' );
}


1;

__END__

=pod

=head1 NAME

App::Pod2Epub - Convert Pod to an ePub eBook.

=head1 DESCRIPTION

This module is used for converting Pod documents to ePub eBooks. The output eBook can be read on a variety of hardware and software eBook readers.

Pod is Perl's I<Plain Old Documentation> format, see L<http://perldoc.perl.org/perlpod.html>. EPub is an eBook format, see L<http://en.wikipedia.org/wiki/Epub>.

This module comes with a L<pod2epub> utility that will convert Pod to an ePub eBook.


=head1 SYNOPSIS


To create a simple filter to convert Pod to an XHTML format suitable for inclusion in an ePub eBook.

    #!/usr/bin/perl -w

    use strict;
    use App::Pod2Epub;


    my $parser = App::Pod2Epub->new();

    if (defined $ARGV[0]) {
        open IN, $ARGV[0]  or die "Couldn't open $ARGV[0]: $!\n";
    } else {
        *IN = *STDIN;
    }

    if (defined $ARGV[1]) {
        open OUT, ">$ARGV[1]" or die "Couldn't open $ARGV[1]: $!\n";
    } else {
        *OUT = *STDOUT;
    }

    $parser->output_fh(*OUT);
    $parser->parse_file(*IN);

    __END__


To convert Pod to ePub using the installed C<pod2epub> utility:

    pod2epub some_module.pm -o some_module.epub

=head1 USING THIS MODULE

At the moment this module isn't very useful on its own. It is mainly in existence as a backend for C<pod2epub>.

It provides a framework to convert Pod documents to an XHTML format suitable for inclusion in an ePub eBook. The ePub creation is handled by L<EBook::EPUB> in C<pod2epub>. Future versions will move that functionality into this module so that it has a utility of its own.

=head1 METHODS

=head2 new()

The C<new> method is used to create a new C<App::Pod2Epub> object.

=head2 Other methods

C<App::Pod2Epub> inherits all of the methods of its parent modules C<Pod::Simple> and C<Pod::Simple::XHTML>. See L<Pod::Simple> for more details if you need finer control over the output of this module.


=head1 SEE ALSO

This module also installs a L<pod2epub> command line utility. See C<pod2epub --help> for details.

L<EBook::EPUB>, a general module for generating EPUB documents.

L<Pod::Simple::XHTML> which this module subclasses.


=head1 ACKNOWLEDGEMENTS

Thanks to Sean M. Burke and the past and current maintainers for C<Pod::Simple>.

Thanks to Oleksandr Tymoshenko for the excellent L<EBook::EPUB>.


=head1 AUTHOR

John McNamara, C<jmcnamara@cpan.org>


=head1 COPYRIGHT & LICENSE

Copyright 2010 John McNamara.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License. See L<http://dev.perl.org/licenses/> for more information.

=cut

