#!/usr/bin/perl
use strict;
use warning;

## script for gtk and WWW::WebKit
use CPAN;

CPAN::Shell->install(
"Test::Harness",
"Test::More",
"Test::Number::Delta",
"File::Spec",
"Pod::Man",
"Pod::Simple",
"Text::Wrap",
"Pod::Escapes",
"ExtUtils::MakeMaker",
"ExtUtils::PkgConfig",
"ExtUtils::Depends",
"Cairo",
"Glib",
"Pango",
"Gtk2");

`apt-get install libglib-perl`;
`apt-get install gssdp-tools`;
`apt-get install libglib-perl`;
`apt-get install libpango-perl`;
`apt-get install libgtk2-perl`;
`apt-get install libgtk2.0-dev`;

