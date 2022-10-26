# provide a mocked Handler and logger class for testing
# writes all output to $log variable

use strict;
use warnings;

use IO::Scalar;
use English qw{_no_match_vars};
use Data::Dumper;

########################################################################
# Usage      : fax_request_handler(ref)
# Purpose    : provides mock methods for request handler, logs at all
#            : levels to scalar passed
# Parameters : ref to scalar
# Returns    : ref to scalar
# Errors     : none
########################################################################
sub faux_request_handler {
########################################################################
  my ($log) = @_;
      
  die q{usage: faux_handler($log)} . "\n"
    if !ref $log;

  no strict 'refs';  ## no critic (ProhibitNoStrict, ProhibitProlongedStrictureOverride)

  my $logger_fh = IO::Scalar->new($log);

  foreach my $m (qw{ error debug warn fatal info trace }) {
    *{ 'Faux::Logger::' . $m } = sub {
      my ( $self, @message ) = @_;

      return _log($self, $logger_fh, @message);
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

  *{'Faux::Handler::DESTROY'} = sub {
    close $logger_fh;
  };
    
  return bless {}, 'Faux::Handler';
}

sub _log {
  my ( $self, $logger_fh, @message ) = @_;

  my $depth = 0;
  my @stack;
  
  while ( my @frame = caller( $depth++ ) ) {
    push @stack, \@frame;
  }
  
  my $frame;
  
  while ( $frame = pop @stack ) {
    last if $frame->[3] !~ /Test::|eval|main/xsm;
  }
  
  my ($caller_package, $lineno) = @{$frame}[(3,2)];

  my $log_message = sprintf '(%s):[%s] %s', $caller_package, $lineno, join q{}, @message;
  
  return print ${logger_fh} $log_message, "\n";
}

1;
