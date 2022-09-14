#!/usr/bin/env perl
# Copyright 2022 Kevin Spencer <kevin@kevinspencer.org>
#
# Permission to use, copy, modify, distribute, and sell this software and its
# documentation for any purpose is hereby granted without fee, provided that
# the above copyright notice appear in all copies and that both that
# copyright notice and this permission notice appear in supporting
# documentation. No representations are made about the suitability of this
# software for any purpose. It is provided "as is" without express or
# implied warranty.
#
################################################################################
 
use Data::Dumper;
use WWW::Pinboard;
use strict;
use warnings;

$Data::Dumper::Indent = 1;

our $VERSION = '0.01';

my $api = WWW::Pinboard->new(token => $token);

my $posts = $api->recent();

print Dumper $posts;
