use strict;
use feature qw(say);
#use v5.10;
 use WWW::Mechanize::Firefox;
my $url = URI->new('http://www.nhtis.org/tolllist.htm');
my $mech = WWW::Mechanize::Firefox->new();
use LWP::UserAgent::ProxyAny;
my $ua = LWP::UserAgent::ProxyAny->new;
$ua->set_proxy_by_name("http://proxy-iind.intel.com:911");
$mech->autodie(0);

#$mech->synchronize('DOMFrameContentLoaded', sub {
$mech->get( $url );
$mech->post(
	"http://www.nhtis.org/TollPlazaService.asmx/GetTollPlazaInfoGrid",
	params=>"{'TollName':''}"
);
#});
say "URL Loaded";
sleep 10;
die "Success" if(!$mech->success);
say "Timeout done";
print $mech->content();
print $_->text . "\n"
    for $mech->find_all_links( text_regex => qr/google/i );
#	use URI;
#	use LWP::UserAgent;
#	use JSON;
#	my $ua = LWP::UserAgent::ProxyAny->new;
#	#$ua->env_proxy; 
#	
#	
#	my $response =$ua->get($url);
#	die "Error: ", $response->status_line unless $response->is_success;
#	my $hsh=$url->query_form;
#	print Dumper($hsh);
#	my $hsh={
#	'ctl00$MainContent$ddldist'=>'BC',
#	'__EVENTTARGET'=>'ctl00$MainContent$ddldist',
#	__ASYNCPOST=>'true'
#	};
#	$url->query_form($hsh);
#	#print $url, "\n";
#	
#	use Data::Dumper;
#	print "Getting URL";
#	my $response = $ua->get( $url );
#	 print "Level 0: " . $response->content . "\n";
#	die "Error: ", $response->status_line unless $response->is_success;
#	
#	 print "Level 0: " . $response->content . "\n";
#	foreach my $ward (@{decode_json($response->content)}){
#	 $hsh->{pLoad}=0;
#	 $hsh->{pLevel}=2;
#	  $hsh->{pLast}=0;
#	
#	#print "x00 Dump Ward" . Dumper($ward);
#	print "x01 Ward" . $ward->{name} . "\n";
#		$hsh->{pID}=$ward->{id};
#		$hsh->{'$filter'}="(Group eq " . $ward->{id} . ")";
#	#	print Dumper ($hsh) . "\n";
#	$url->query_form( $hsh);
#	#	print "url $url \n";
#		my $response = $ua->get( $url );
#		die "Error: ", $response->status_line unless $response->is_success;
#	
#		print "Ward P Codes :" . $response->content . "\n";
#		
#	
#	 $hsh->{pLoad}=1;
#	 $hsh->{pLevel}=2;
#	 $hsh->{pLast}=1;
#	 $hsh->{'$filter'}=undef;
#	 #print "x02 wdata" . Dumper( decode_json($response->content));
#	foreach my $project (@{decode_json($response->content)}){
#		$hsh->{pID}=$project->{id};
#	$url->query_form( $hsh);
#		
#		my $response = $ua->get( $url );
#		die "Error: ", $response->status_line unless $response->is_success;
#	 print "Project Data:" . $response->content . "\n";
#	
#	
#	}
#	#die "Stopping at 1";
#	sleep 5;
#	}
#	
