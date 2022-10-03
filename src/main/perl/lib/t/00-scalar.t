use strict;
use warnings;

use Test::More tests => 5;
use Data::Dumper;
use English qw{-no_match_vars};

BEGIN {
  use lib qw{ . Bedrock/Text };

  use_ok('TagX::Scalar');
}

my $test_string = 'xyzabc';

my $scalar = TagX::Scalar->new($test_string);

subtest 'align' => sub {
  my $str = $scalar->align( 'center', 12 );

  ok( length $str == 12, 'length is 12' )
    or diag( Dumper( [ $str, length $str ] ) );

  ok( $str eq '   xyzabc   ', 'centered' )
    or diag( Dumper( [ $str, ${$scalar} ] ) );

  ok( ${$scalar} eq 'xyzabc', 'original not altered' )
    or diag( Dumper( [ $str, ${$scalar} ] ) );

  $str = $scalar->align( 'left', 12 );
  ok( length $str == 12, 'length is 12' )
    or diag( Dumper( [ $str, length $str ] ) );

  ok( $str eq 'xyzabc      ' && ${$scalar} eq $test_string, 'left' )
    or diag( Dumper( [ $str, ${$scalar}, length $str ] ) );

  $str = $scalar->align( 'right', 12 );
  ok( length $str == 12, 'length is 12' )
    or diag( Dumper( [ $str, length $str ] ) );

  ok( $str eq '      xyzabc' && ${$scalar} eq $test_string, 'right' )
    or diag( Dumper( [ $str, ${$scalar}, length $str ] ) );

  $str = eval { $scalar->align( 'foo', 4 ); };

  ok( !$str && $EVAL_ERROR, 'bad args throws exception' );
};

subtest 'base64' => sub {
  require MIME::Base64;

  my $str = $scalar->base64_encode();

  ok( $str eq MIME::Base64::encode_base64($test_string), 'encode' )
    or diag(
    Dumper( [ $str, ${$scalar}, MIME::Base64::encode_base64($test_string) ] )
    );

  ok( $scalar->base64_decode($str) eq $test_string, 'decode' )
    or diag(
    Dumper( [ $str, ${$scalar}, MIME::Base64::encode_base64($test_string) ] )
    );

  $str = $scalar->base64_encode('abc');
  ok( $str ne $scalar->base64_encode, 'encode w/arg' )
    or diag( Dumper( [ $str, ${$scalar} ] ) );

  ok( $scalar->base64_decode($str) eq 'abc', 'decode w/arg' )
    or diag( Dumper( [ $str, ${$scalar} ] ) );

  my $new_scalar = $scalar->new($str);
  ok( $new_scalar->base64_decode eq 'abc', 'decode wo/arg' );
};

subtest 'length' => sub {
  ok( $scalar->length == ( length ${$scalar} ), 'length is 6' );
};

subtest 'tr' => sub {

  my $str = $scalar->tr( 'xyz', 'abc' );

  ok( $str eq 'abcabc', 'tr/xyz/abc' )
    or diag( Dumper( [ $str, ${$scalar} ] ) );

  ok( ${$scalar} eq 'xyzabc', 'original not altered' )
    or diag( Dumper( [ $str, ${$scalar} ] ) );
};

1;

__END__

__DATA__

[x] align
[x] align_center
[x] align_left
[x] align_right
[ ] base64
[ ] decode
[ ] format_time
[ ] hmac_sha1
[ ] hmac_sha224
[ ] hmac_sha256
[ ] hmac_sha384
[ ] hmac_sha512
[ ] htmlencode
[ ] isEmpty
[ ] json
[ ] ltrim
[ ] matches
[ ] or
[ ] replace
[ ] rtrim
[ ] sign
[ ] split
[ ] toggle
[ ] tr
[ ] trim
[ ] urlencode
