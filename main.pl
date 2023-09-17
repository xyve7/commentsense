#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use HTTP::Request;

my @srcs;
my @dests;
my @find;
my @remove;

GetOptions(
    'remove|r' => \@remove,
    'src|s=s@' => \@srcs,
    'dest|o=s@' => \@dests,
    'find|f=s@' => \@find,
);

if(@remove) {
    # Validate input
    (@srcs != @dests) && die "number of source files given is not the same as the number of destination files given\n";

    for my $i (0..$#srcs) {
        open my $in, '<', $srcs[$i] or die "couldn't open file: $!";
        open my $out, '>', $dests[$i] or die "couldn't open file: $!";

        my $code = do { local $/; <$in> };

        $code =~ s/^\/\/.*|^\/\*[^*]*\*\/$//gm;

        print $out $code;

        close($in);
        close($out);
    }
} else {
    die "unknown option\n"
}