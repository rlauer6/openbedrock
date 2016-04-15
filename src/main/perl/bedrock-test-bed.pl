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

  return ( input => $text, error => $tx->output, output => $output );
}

sub bedrock_load_tests {
  $file = sprintf("t/%s.txt", shift);

  my $json = eval {
    local $/ = undef;
    open (my $fh, "<" . $file) or die "can't open $file";
    $json = <$fh>;
    close $fh;
    from_json($json, {  relaxed => 1 });
  };
}

sub bedrock_run_tests {
  my $tests = shift;

  foreach my $t (@{$tests}) {
    my %r = bedrock($t->{test}, %{$t->{param}});
    
    for ( $t->{test_if}) {
      /^eq/ && do {
	ok($r{output} eq $t->{result}, $t->{name});
      };
      
      /^ne/ && do {
	ok($r{output} ne $t->{result}, $t->{name});
      };

      note(sprintf("[%s]:[%s]:[%s]\n", @r{qw/input output/}, scalar(@{$r{error}}))) if @{$r{error}};
    }
    
  }
}

1;
