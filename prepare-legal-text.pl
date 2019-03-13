#!/usr/bin/env perl

use strict;
use warnings;

die 'Usage: perl prepare-license-text.pl [source] [prepared] [version]'
	unless @ARGV >= 2;

my ($source, $prepared, $version) = @ARGV;

my $front_matter = '';
open(my $FRONT_MATTER_WRITE, '>', \$front_matter);
die 'Could not open prepared file: ' . $!
	unless open(my $PREPARED_FM_READ, '<:encoding(UTF-8)', $prepared);
die 'Could not read front matter' unless <$PREPARED_FM_READ> eq "+++\n";
while (($_ = <$PREPARED_FM_READ>) ne "+++\n") {
	print $FRONT_MATTER_WRITE $_;
}
close $FRONT_MATTER_WRITE;
close $PREPARED_FM_READ;

die 'Could not open source file: ' . $!
	unless open(my $SOURCE, '<:encoding(UTF-8)', $source);
my @license_header = (<$SOURCE> =~ m/\# (.*)/);
my $license_name = $license_header[0];

open(my $FRONT_MATTER_READ, '<', \$front_matter);
die 'Could not open prepared file for writing: ' . $!
	unless open(my $PREPARED_WRITE, '>', $prepared);
print $PREPARED_WRITE "+++\n";
while (<$FRONT_MATTER_READ>) {
	print $PREPARED_WRITE $_;
}
print $PREPARED_WRITE "+++\n";
print $PREPARED_WRITE "\n";
print $PREPARED_WRITE '# ' . $license_name . ', Version ' . $version . "\n";
while (<$SOURCE>) {
	print $PREPARED_WRITE $_;
}
close $FRONT_MATTER_WRITE;
close $PREPARED_WRITE;
