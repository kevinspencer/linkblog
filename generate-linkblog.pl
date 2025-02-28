#!/usr/home/muppet/perl5/perlbrew/perls/perl-5.36.1/bin/perl
# Copyright 2022-2023 Kevin Spencer <kevin@kevinspencer.org>
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
use DateTime;
use File::Copy;
use Time::Seconds;
use WWW::Pinboard;
use utf8::all;
use strict;
use warnings;

$Data::Dumper::Indent = 1;

our $VERSION = '0.09';

my $token     = $ENV{PINBOARD_TOKEN} or die "No pinboard API token found\n";
my $final_dir = $ENV{LINKBLOG_DIR} or die "No linkblog directory found\n";

my $pinboard = WWW::Pinboard->new(token => $token);

my $list = $pinboard->recent(count => 30);

die "Could not retrieve latest posts from pinboard!!\n" if (! $list);

my $header_template = 'linkblog-header.html';
my $footer_template = 'linkblog-footer.html';
my $final_linkblog  = 'index.php';

open(my $lbfh, '>', $final_linkblog)  || die "Could not create $final_linkblog - $!\n";
open(my $htfh, '<', $header_template) || die "Could not open $header_template - $!\n";
open(my $ftfh, '<', $footer_template) || die "Could not open $footer_template - $!\n";

print $lbfh $_ while(<$htfh>);

close($htfh);

my @title_icons = (
    'fa-solid fa-right-long',
    'fa-solid fa-shower',
    'fa-solid fa-rocket',
    'fa-solid fa-mug-saucer',
    'fa-solid fa-sun',
    'fa-solid fa-star',
    'fa-solid fa-hippo',
    'fa-solid fa-cloud',
    'fa-solid fa-moon',
    'fa-solid fa-robot',
    'fa-solid fa-mountain-city',
    'fa-solid fa-tree',
    'fa-solid fa-fire',
);

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

my $dt1 = DateTime->now(time_zone => 'America/Phoenix');

my $previous_random_number;

for my $post (@{$list->{posts}}) {

    my $dt2;
    if ($post->{time} =~ /^(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)Z$/) {
        $dt2 = DateTime->new(year => $1, month => $2, day => $3, hour => $4, minute => $5, second => $6, time_zone  => 'GMT');
        $dt2->set_time_zone("America/Phoenix")
    }

    my $time_ago_string = format_time_ago_string($dt1->epoch(), $dt2->epoch());

    # so we don't get the same icon twice in a row...
    my $current_random_number = int(rand(@title_icons));

    if ($previous_random_number) {
        until ($current_random_number != $previous_random_number) {
            $current_random_number = int(rand(@title_icons));
        }
    }

    $previous_random_number = $current_random_number;

    my $icon = $title_icons[$current_random_number];

    print $lbfh "    <li class=\"wppb-bookmark\">\n";
    print $lbfh "        <div class=\"wppb-header\"><a class=\"wppb-title\" href=\"$post->{href}\"><i class=\"$icon\"></i> $post->{description}</a></div>\n";
    print $lbfh "        <div class=\"wppb-description\">$post->{extended}</div>\n";
    print $lbfh "        <div class=\"wppb-footer\">\n";
    print $lbfh "            <i class=\"fa fa-clock-o\" aria-hidden=\"true\"></i>\n";
    print $lbfh "            <abbr class=\"wppb-date\" title=\"$post->{time}\">$time_ago_string</abbr>\n";
    print $lbfh "        </div>\n";
    print $lbfh "    </li>\n";
}

print $lbfh "</ul>\n";

my $now_string = $dt1->day_abbr() . ', ' . $dt1->month_abbr() . ' ' . sprintf("%02d", $dt1->day()) . ', ' . $dt1->year() . ' ' . sprintf("%02d", $dt1->hour()) . ':' . sprintf("%02d", $dt1->min()) . ':' . sprintf("%02d", $dt1->second());

while (<$ftfh>) {
    my $line = $_;
    if ($line =~ /RUNTIME/) {
        $line =~ s/RUNTIME/$now_string/;
    }
    print $lbfh $line;
}

close($lbfh);
close($ftfh);

move($final_linkblog, $final_dir) || die "Couldn't move $final_linkblog to $final_dir - $!\n";

sub format_time_ago_string {
    my ($timestamp_now, $timestamp_then) = @_;

    my $duration = ($timestamp_now - $timestamp_then);

    my $duration_string;
    if ( $duration > ONE_YEAR ) {
        my $pluralization = int($duration / ONE_YEAR) == 1 ? 'year' : 'years';
        $duration_string = sprintf "%d $pluralization ago", $duration / ONE_YEAR;
        return $duration_string;
    } elsif ($duration > ONE_DAY) {
        my $pluralization = int($duration / ONE_DAY) == 1 ? 'day' : 'days';
        $duration_string = sprintf "%d $pluralization ago", $duration / ONE_DAY;
        return $duration_string;
    } elsif ($duration > ONE_HOUR) {
        my $pluralization = int($duration / ONE_HOUR) == 1 ? 'hour' : 'hours';
        $duration_string = sprintf "%d $pluralization ago", $duration / ONE_HOUR;
        return $duration_string;
    } else {
        my $pluralization = int($duration / ONE_MINUTE) == 1 ? 'minute' : 'minutes';
        $duration_string = sprintf "%d $pluralization ago", $duration / ONE_MINUTE;
        return $duration_string;
    }
}
