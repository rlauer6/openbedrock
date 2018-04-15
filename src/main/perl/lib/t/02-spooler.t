use strict;
use warnings;

use Data::Dumper;
use JSON;

use Test::More tests => 5;

BEGIN {

  use Module::Loaded;
  use File::Temp qw/tempfile/;
  
  no strict 'refs';
  
  my ($fh, $filename) = tempfile();
  close $fh;
  
  *{'Redis::new'} = sub { return bless {}, 'Redis'; };
  *{'Redis::filename'} = sub { return $filename };
  *{'Redis::publish'} = sub {
    shift;
    open $fh, ">>$filename";
    print $fh join("\n", @_);
    close $fh;
  };
  *{'Redis::DESTROY'} = sub { unlink "$filename" };
  
  mark_as_loaded(Redis);
  
  use_ok('Bedrock::Log::Spooler');
}

my $spooler = Bedrock::Log::Spooler->instance;

$spooler->channel('test-channel');
$ENV{'02-SPOOLER'} = $$;
$spooler->publish_env(1);
$spooler->publish(["message"], foo => 'bar');

open (my $fh, "<", $spooler->redis_client->filename) or BAIL_OUT("could open temp file for reading");
  
my $channel = <$fh>;
chomp $channel;
is($channel, 'test-channel', 'published to correct channel');

my $content = <$fh>;
chomp $content;

my $json = eval {
  from_json($content);
};

ok(ref($json), 'published JSON content');
ok(exists $json->{env}, 'publish %ENV');

my $env = eval {
  from_json($json->{env});
};

ok(ref($env) && $env->{'02-SPOOLER'} eq "$$", 'publish 02-SPOOLER to %ENV');

close $fh;
