# provide a mocked Handler and logger class for testing
# writes all output to $log variable

use strict;
use warnings;

use IO::Scalar;
use English qw{_no_match_vars};

sub faux_handler {
  my ($log) = @_;

  die q{usage: faux_handler($log)} . "\n"
    if !ref $log;

  no strict 'refs';  ## no critic (ProhibitNoStrict, ProhibitProlongedStrictureOverride)

  my $logger_fh = IO::Scalar->new($log);

  foreach my $m (qw{ error debug warn fatal info trace }) {
    *{ 'Faux::Logger::' . $m } = sub {
      print ${logger_fh} @_, "\n";
    };
  }

  *{'Faux::Handler::log'} = sub {
    return bless {}, 'Faux::Logger';
  };

  *{'Faux::Handler::filename'} = sub {
    return $PROGRAM_NAME;
  };

  *{'Faux::Handler::uri'} = sub {
    return q{/};
  };

  *{'Faux::Handler::content_type'} = sub {
    return 'text/html';
  };

  return bless {}, 'Faux::Handler';
}

1;
