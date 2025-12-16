#!/usr/bin/env perl
# - unit test for testing Bedrock::Context::upload_file() method

########################################################################
package main;
########################################################################

use strict;
use warnings;

use Test::More qw(no_plan);

use Bedrock::Context;
use Carp;
use Data::Dumper;
use English qw(-no_match_vars);
use File::Temp qw(tempfile);
use HTTP::Request::Common qw(POST);
use IO::Scalar;

our $LOREM_IPSUM = <<'END_OF_TEXT';
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
minim veniam, quis nostrud exercitation ullamco laboris nisi ut
aliquip ex ea commodo consequat. Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum
END_OF_TEXT

########################################################################
# Usage      : create_upload_stream()
# Purpose    : create an upload stream emulating file uploads by calling
#              HTTP::Request::Common::POST
# Parameters : none
# Returns    : tuple (content, filename)
# Errors     : none
########################################################################
sub create_upload_stream {
########################################################################
  my ( $fh, $filename ) = tempfile( 'upload-file-XXXXXX', SUFFIX => '.txt' );

  print {$fh} $LOREM_IPSUM;
  close $fh;

  # Create the full HTTP::Request object
  my $request = POST(
    undef,
    Content_Type => 'form-data',
    Content      => [ uploaded_file => [$filename] ],
  );

  # remove from cwd
  unlink $filename;

  # Return the REQUEST OBJECT, not just the content string
  return ( $request, $filename );
}

my ( $request, $filename ) = create_upload_stream();
my $content = $request->content;

local $ENV{REQUEST_METHOD} = 'POST';
local $ENV{CONTENT_TYPE}   = $request->header('Content-Type');
local $ENV{CONTENT_LENGTH} = length $content;

my $ctx = Bedrock::Context->new(
  config => {
    UPLOAD_PATH    => '/tmp',
    LOG4PERL_LEVEL => 'error',
  },
  request => sub { },  # Dummy sub needed to satisfy Bedrock::Context validation
);

my @members = qw(
  atime
  blksize
  blocks
  cipher
  content-type
  ctime
  dev
  file
  gid
  ino
  md5_digest
  mode
  mtime
  nlink
  rdev
  size
  uid
  uploaded_file
);

my $file_info;

########################################################################
subtest 'update returns a Bedrock::Hash' => sub {
########################################################################

  {
    my $fh = IO::Scalar->new( \$content );

    local *STDIN = $fh;

    $file_info = $ctx->upload_file('uploaded_file');

    diag( Dumper( [ file_info => $file_info ] ) );

    close $fh;
  }

  isa_ok( $file_info, 'Bedrock::Hash', 'return a hash of file info' );

  is_deeply( [ sort keys %{$file_info} ], [@members], 'contains all members' );

  is( $file_info->{uploaded_file}, $filename, 'uploaded_file  member is correct' );
};

########################################################################
subtest 'file uploaded' => sub {
########################################################################
  ok( -e "/tmp/$filename", 'file uploaded' );

  is( $file_info->{size}, -s "/tmp/$filename", 'size is same as file size' );

  is( $file_info->{size}, length $LOREM_IPSUM, 'reported size is same as string written' );

  open my $fh, '<', "/tmp/$filename"
    or BAIL_OUT("could not open /tmp/$filename for reading");

  local $RS = undef;

  is( <$fh>, $LOREM_IPSUM, 'content uploaded correctly' );

  close $fh;
};

done_testing;

END {
  # remove uploaded file
  unlink "/tmp/$filename";
}

1;

__END__
