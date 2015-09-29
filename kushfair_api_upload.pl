#!/usr/bin/perl -w
use strict;

$main::kushfair_url = 'http://qa.kushfair.com:80';
$main::user_oauth2_key = 'CUVDGRSHEEQKA7LH';

use JSON::XS;
use Data::Dumper;

use lib '/usr/lib/xymon/server/ext/perl_modules';
use Market::OAuth2Client;

# this function takes in a perl hash ref, in the following format
my %ref;

$ref{'parameter'}{'inventory'}[0]{'inventorytype'} = 45 ;
$ref{'parameter'}{'inventory'}[0]{'id'} = '1234567887654321';
$ref{'parameter'}{'inventory'}[0]{'productname'} = 'BigBroProductTest';
$ref{'parameter'}{'inventory'}[0]{'remaining_quantity'} = 500;
$ref{'parameter'}{'inventory'}[0]{'strain'} = 'BigBroStrainTest';
$ref{'parameter'}{'inventory'}[0]{'usable_weight'} = 50;
$ref{'parameter'}{'inventory'}[0]{'wet'} = 1;	
#$ref{'parameter'}{'inventory'}[0]{'description'} = hhh;	
#$ref{'parameter'}{'inventory'}[0]{'price'} = $price;
#$ref{'parameter'}{'inventory'}[0]{'cost_per_unit'} = $cost;
$ref{'parameter'}{'inventory'}[0]{'grade'} = 'premo';
#$ref{'parameter'}{'inventory'}[0]{'pricepoint'} = \@pp;
#$ref{'parameter'}{'inventory'}[0]{'action'} = 'upload';
$ref{'action'} = 'upload';
$ref{'url'} = '/api/v1/inventory/upload';
$ref{'timeout'} = 45;
$ref{'oauth2_key'} = 'CUVDGRSHEEQKA7LH';

my $a = kushfair_jsonsendrecv(\%ref);
print Dumper($a);


# some of these fields can be blank. important ones are
# type
# id
# productname
# remainingquantity

# the url key => value needs to be concatenated with "http://qa.kushfair.com";
# i just handle it as a global variable 
# oauth2_key, is the respective key of the user your testing with
# its in the tokes.txt file

sub kushfair_jsonsendrecv
{
	my ($sendref) = @_;

	# require stuff.....
	require Market::OAuth2Client; 
	require JSON::XS;
	require Data::Dumper; Data::Dumper->import;

	local $Data::Dumper::Purity = 1;
	local $Data::Dumper::Deepcopy = 1;
		
	my $json = JSON::XS->new;
	my $coder = JSON::XS->new->ascii->pretty->allow_nonref;
	
	# get config for accessing KushFair.. Pass an OAuth2Key if you want to specify one, otherwise, it defaults to the current users OAuth2Key, if they have one....
	my $config;
	if($sendref->{oauth2_key}) { $config = get_kushfair_config($sendref->{oauth2_key}); }
	else{ $config = get_kushfair_config(); }
	
	if(!$config) { return(-1); }
	
	# instantiate a new OAuth2Client, for connecting with KushFair
	my $client = Market::OAuth2Client->new($config);	
	if($sendref->{timeout}) { $client->agent->timeout($sendref->{timeout}); }
	
	my $api_url = $sendref->{url};
	my $url = $main::kushfair_url.$api_url;
	
	if(!$url) { $url = "http://qa.kushfair.com:80"; }
	
	if(!$sendref->{action}) { my %recvref = ( error => 'Internal error. No \'Action\' defined.', success => 0 ); return(\%recvref); }
	my $action = $sendref->{action};
	
	# get the params were passing to the KushFair API, pack them in their own hash....
	my %params = ();
	if($sendref->{parameter}){ foreach my $key ( sort keys %{ $sendref->{parameter} } ) { $params{$key} = $sendref->{parameter}->{$key}; } }
	
	# make sure we get every record... 
	if(!$params{'_count'} && $action eq 'get'){ $params{'_count'} = 2000; }
	
	# encode to JSON format. This is only necessary if we are uploading inventory....
	my $pretty_printed_unencoded = eval { $coder->encode (\%params); } || { sub { my %recvref = ( error => 'There was an error. Please try again later.', success => 0 ); return(\%recvref); } };
	
	my %file = ();
	$file{file} = $pretty_printed_unencoded;
	
	my $res;
	if($action eq 'post') { $res = $client->post($url, undef, { %params }); }
	elsif($action eq 'get') { $res = $client->get($url, undef, { %params });  }
	elsif($action eq 'upload') { $res = $client->post($url, undef, { %file }); }
	elsif($action eq 'put') { $res = $client->put($url, undef, { %params }); }
	elsif($action eq 'delete') { print 'to do...'; }
		
	if(!defined($res))
	{
		my %recvref = ( error => 'No data received from the KushFair Server. Please try again later.', => success => 0 );
		$main::kushfair_website_status = 0;	
		return(\%recvref);
	}
	elsif($res =~ /code/)
	{
		my %recvref = ( error => 'There seems to be network issues. Please try again later.', => success => 0 );
		$main::kushfair_website_status = 0;	
		return(\%recvref);
	}

	my $return = eval { $res->decoded_content; } || 
	{ 
		sub 
		{ 
			my %recvref = ( error => 'There was an error. Please try again later.', success => 0 ); 
			$main::kushfair_website_status = 0;
			return(\%recvref); 
	
		} 
	};
	
	my $return2 = eval { $json->decode($return); } || 
	{ 
		sub 
		{ 
			my %recvref = ( error => 'There was an error. Please try again later.', success => 0 ); 
			$main::kushfair_website_status = 0;
			return(\%recvref); 
		} 
	};
	
	$main::kushfair_website_status = 1;
	
	# KushFair messages return in an array, concatinate them, and return them, as one message...	
	my $message;	
	foreach (@{ $$return2{messages} }) { $message .= $_."\n"; }
	
	chop($message);
	$$return2{message} = $message;
	
	# if we passed params, show them.. makes debugging easier....
	if(%params) { $$return2{parameters} = \%params; }
	if($sendref->{oauth2_key}) { $$return2{oauth2_key} = $sendref->{oauth2_key}; }
	if($config) { $$return2{authorization_params} = $config; }
	
	# API stuff..... the api returns 'true'/'false' or 1/0... Default to boolean... 
	if($return2->{success} eq 'true') { $$return2{success} = 1; }
	elsif($return2->{success} eq 'false') { $$return2{success} = 0; }

	# if we want the data_dummp, for w.e reason, its there... 
	my $data_dump = Dumper($return2);

	if(-e "kushfair_debug.txt")
	{
		# show the final result... 
		warn "Action: $action, URL: $url....";
		warn $data_dump;
		
		# log it... 
		my @split = split('/', $api_url);
		my $dest = $split[3];
		
		my $filename = "$action\_\@$dest.txt";
		to_text($return2, $filename);
	}
	
	return($return2);
}

# modify this function with real data 
# eliminate the global variables
sub get_kushfair_config
{
	my ($oauth2key) = @_;
	
	# if we dont specify an OAuth2Key, default to the current logged in user
	if(!$oauth2key) { $oauth2key = $main::user_oauth2_key; }
	if(!$oauth2key) { $oauth2key = get_admin_oauth2_key(); }
	if(!$oauth2key) 
	{
		# if were here, it seems we have KushFair access.. But apparently, no users have OAuth2_Keys.. Do something to get them a key..??  
		 
	}

	if(length($main::kushfair_url) <= 0) { $main::kushfair_url = 'http://qa.kushfair.com:80'; };

	my $config = {
			http_base         => $main::kushfair_url,
		    authorize_uri     => $main::kushfair_url."/oauth2/authorize",
		    access_token      => $oauth2key,
		   	scope             => 'api'
 		};
	
	return($config);	
}
