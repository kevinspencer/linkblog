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

our $VERSION = '0.03';

my $token = $ENV{PINBOARD_TOKEN} or die "No pinboard API token found\n";

my $pinboard = WWW::Pinboard->new(token => $token);

my $list = $pinboard->recent(count => 25);

die "Could not retrieve latest posts from pinboard!!\n" if (! $list);

my $header_template = 'linkblog-header.html';
my $footer_template = 'linkblog-footer.html';
my $final_linkblog  = 'index.html';

open(my $lbfh, '>', $final_linkblog)  || die "Could not create $final_linkblog - $!\n";
open(my $htfh, '<', $header_template) || die "Could not open $header_template - $!\n";
open(my $ftfh, '<', $footer_template) || die "Could not open $footer_template - $!\n";

print $lbfh $_ while(<$htfh>);

close($htfh);

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

print $lbfh "<ul class=\"wppb-bookmarks\">\n";

for my $post (@{$list->{posts}}) {
    print $lbfh "    <li class=\"wppb-bookmark\">\n";
    print $lbfh "        <div class=\"wppb-header\"><a class=\"wppb-title\" href=\"$post->{href}\"><i class=\"fa fa-star\"></i> $post->{description}</a></div>\n";
    print $lbfh "        <div class=\"wppb-description\">$post->{extended}</div>\n";
    print $lbfh "        <div class=\"wppb-footer\">\n";
    print $lbfh "            <i class=\"fa fa-clock-o\" aria-hidden=\"true\"></i>\n";
    print $lbfh "            <abbr class=\"wppb-date\" title=\"$post->{time}\">6 days ago</abbr>\n";
    print $lbfh "        </div>\n";
    print $lbfh "    </li>\n";
}

print $lbfh "</ul>\n";

print $lbfh $_ while(<$ftfh>);

close($lbfh);
close($ftfh);
