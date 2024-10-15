#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

########################################################################
package MIME::Lite;
########################################################################

use Data::Dumper;

our $OPTIONS;

########################################################################
sub new {
########################################################################
  my ( $class, %options ) = @_;

  $OPTIONS = \%options;

  return bless \%options, $class;
}

########################################################################
sub send {
########################################################################
  my ( $self, %options ) = @_;

  return 1;
}

########################################################################
package main;
########################################################################

BEGIN {
  use Module::Loaded;

  mark_as_loaded(MIME::Lite);

  use_ok('Bedrock::Template::Email');
}

use Data::Dumper;
use English qw(-no_match_vars);

my $text = <<'END_OF_TEMPLATE';
Hello <var $world>!
END_OF_TEMPLATE

########################################################################
subtest 'new' => sub {
########################################################################
  my $template = Bedrock::Template::Email->new();

  isa_ok( $template, 'Bedrock::Template::Email' );

  $template->text($text);
  is( $text, ${ $template->text() }, 'Bedrock::Template::Email->text()' )
    or diag( "text: $text, " . ${ $template->text() } );

  eval {
    return $template->email_message(
      $text,
      world   => 'World',
      to      => 'fred@openbedrock.net',
      from    => 'barney@openbedrock.net',
      subject => 'test',
    );
  };

  ok( !$EVAL_ERROR, 'send an email' );

  ok( $MIME::Lite::OPTIONS->{Data} eq "Hello World!\n", 'email parsed' );
};

done_testing;

1;
