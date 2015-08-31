#!/usr/bin/perl -w
use strict;
use Getopt::Long;
 
my ($fh, $help, $start_time, $end_time, @array, $logfile);
 
#-- prints usage if no command line parameters are passed or there is an unknown
#   parameter or help option is passed
usage() if ( @ARGV < 3 or
          ! GetOptions('help|?' => \$help, 'starttime=s' => \$start_time, 'endtime=s' => \$end_time, 'file=s' =>  \$logfile )
          or defined $help );
 
sub usage
{
  print "Unknown option: @_\n" if ( @_ );
  print "Example:[ ./badboyip.pl --start 10:00 --end 11:00 --file /var/log/access_log ] [--help|-?]\n";
  exit;
}

my @out = `sed -n \'/2015:$start_time/,/2015:$end_time/p\' $logfile`; 

if (!open $fh, '<', "$logfile")
    {
        die "Can't open file $!";
    }


my @counted;

## grepping for the first string of characters in each line which is the ip
for my $line ( @out )
{
	if ( $line =~ m/^(\S+)/ )

	{

	    push @counted, $1;

	}

}


my %count;

foreach my $str (@counted)
{
    $count{$str}++;
}

my $iteration = 0;


foreach my $name (reverse sort { $count{$a} <=> $count{$b} } keys %count)
{
    no warnings 'uninitialized';

    if ( $iteration == 10 )
    {
        last();
    }

    ## get dns name of IP (owner) 
    #my $dnsname = gethostbyaddr(inet_aton($name), AF_INET);

    printf "%-21s %-10s %s\n", $name, $count{$name};
    #printf "%-21s\n", $name;
    $iteration++;
}



