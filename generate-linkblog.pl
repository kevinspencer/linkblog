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
use utf8::all;
use strict;
use warnings;

$Data::Dumper::Indent = 1;

our $VERSION = '0.02';

my $token = $ENV{PINBOARD_TOKEN} or die "No pinboard API token found\n";

my $pinboard = WWW::Pinboard->new(token => $token);

my $list = $pinboard->recent();

# $VAR1 = {
#   'description' => 'Nerd Fonts - Iconic font aggregator, glyphs/icons collection, & fonts patcher',
#   'time' => '2022-09-12T18:41:48Z',
#   'hash' => '3d6d99a5d6190c51ef24d7de94c2d4e7',
#   'tags' => '',
#   'meta' => '20251fb95fed9df18bc2945a04e606ad',
#   'shared' => 'yes',
#   'extended' => 'does what it says on the tin',
#   'href' => 'https://www.nerdfonts.com/',
#   'toread' => 'no'
# };

for my $post (@{$list->{posts}}) {
    print "<a href=\"$post->{href}\">$post->{description}</a>\n";
}
