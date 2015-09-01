#!/usr/bin/perl

use strict;
use warnings;


## Top 10 requested successful pages 

my $x = "access_log";

my $lc = 0;
open my $file, "<", "$x" or die $!;
$lc++ while <$file>;
close $file;

## opening access_log for parsing
open(FILE, "<access_log") or die "can't open file $!";
my @array = <FILE>;

my @counted;

my $xyz = 0;
for my $line ( @array ) 
{
	if ( $line =~ m/(?:[GET|POST]) (\S+) HTTP\/1.\d\" (2\d{2}) / ) 
    {
	    push @counted, ($1, $2);
            $xyz++;

    }
}
print "This file has $lc lines.\n";


my %count;
 
foreach my $str (@counted) 
{
    $count{$str}++;
}

## We only want the 10 most requested pages.
my $iteration = 0;

foreach my $name (reverse sort { $count{$a} <=> $count{$b} } keys %count) 
{
    no warnings 'uninitialized';    
    
    if ( $iteration == 10 ) 
    { 
        last(); 
    }
print "\n\n";
    
#    #printf "%-21s %-10s\n", $name, $count{$name};
print "$name\n";
print "[$count{$name} hits]\n";

    ##printf "%-21s\n", $name;
    $iteration++;
}
print "This file has $lc lines.\n";
print "This file had $xyz 2XX http requests.\n";

my $r = ($xyz * 100);
my $y = $r / $lc; 

print "The log file has $y% successful requests\n";

__END__


