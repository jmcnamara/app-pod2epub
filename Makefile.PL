#!/usr/bin/perl -w

use ExtUtils::MakeMaker;
use strict;

# Ebook::Epub needs Moose.
require 5.008;

my %deps = (
        'Pod::Simple'  => 0,
        'EBook::EPUB'  => 0,
        'Getopt::Long' => 0,
        'Pod::Usage'   => 0,
        'Data::UUID'   => 0,
        'File::Temp'   => 0,
);

my %resources = (
    repository  => 'http://github.com/jmcnamara/app-pod2epub',
);

my %params = (
    'AUTHOR'        => 'John McNamara (jmcnamara@cpan.org)',
    'ABSTRACT_FROM' => 'lib/App/Pod2Epub.pm',
    'NAME'          => 'App::Pod2Epub',
    'VERSION_FROM'  => 'lib/App/Pod2Epub.pm',
    'NEEDS_LINKING' => 0,
    'dist'          => { COMPRESS => 'gzip --best', SUFFIX => 'gz' },
    'EXE_FILES'     => ['bin/pod2epub'],
    'LICENSE'       => 'perl',
    'PREREQ_PM'     => \%deps,
);

if ( $ExtUtils::MakeMaker::VERSION ge '6.46' ) {
    $params{META_MERGE} = { resources => \%resources };
}

WriteMakefile(%params);

