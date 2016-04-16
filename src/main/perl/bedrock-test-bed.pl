#!/usr/bin/perl

use IO::Scalar;
use JSON;

sub bedrock {
  my $text = shift;
  my %param = @_;

  require Text::TagX;

  my $output = '';

  my $tx = Text::TagX->new( 
			   IO::Scalar->new(\$text),
			   IO::Scalar->new(\$output)
			  );

  $tx->param(%param);

  eval {
    $tx->output;
  };
  
  return ( input => $text, error => $@, output => $output );
}

sub bedrock_load_tests {
  my $file = shift;
  my $use_yaml = shift;

  $file = sprintf("t/%s.txt", $file);
  my $tests;

  if ( $use_yaml ) {
    $tests = [LoadFile($file)];
  }
  else {
    $tests = eval {
      local $/ = undef;
      open (my $fh, "<" . $file) or die "can't open $file";
      $tests = <$fh>;
      close $fh;
      from_json($tests, {  relaxed => 1 });
    };
    
    die "invalid JSON in test spec: $@"
      if $@;
  }

  $tests;
}

sub bedrock_run_tests {
  my $tests = shift;

  foreach my $t (@{$tests}) {
    my %r = bedrock($t->{test}, %{$t->{param}});

    # are we looking for an error
    if ( $t->{error} ) {
      $r{output} = $r{error};
      $t->{result} = $t->{error};
    }

    my $op = $t->{op} || 'is';

    if ( ref($op) ) {
      $op = 'cmp_ok';
    }

    my $success;
    
    for ($op) {
      /^is$/ && do {
	$success = is($r{output}, $t->{result}, $t->{name});
      };

      /^isnt$/ && do {
	$success = is($r{output}, $t->{result}, $t->{name});
      };

      /^like$/ && do {
	$success = like($r{output}, $t->{result}, $t->{name});
      };

      /^unlike$/ && do {
	$success = unlike($r{output}, $t->{result}, $t->{name});
      };
      
      /^is_deeply/ && do {
	$success = is_deeply($r{output}, $t->{result}, $t->{name});
      };

      /^cmp_ok/ && do {
	$success = cmp_ok($r{output}, $t->{op}->{cmp_ok}, $t->{result}, $t->{name});
      };

      unless ( $success ) {
	if ( $r{error} ) {
	  note(sprintf("[%s]:[%s]:[%s]\n", @r{qw/input output/}, $r{error}));
	}
	else {
	  note(sprintf("[%s]:[%s]\n", @r{qw/input output/}));
	}
      }

    }
  }
}

1;
