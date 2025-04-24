#!/usr/bin/env perl

use strict;
use warnings;

use Bedrock::XML;
use Carp;
use Data::Dumper;
use English qw(no_match_vars);
use JSON;
use YAML::XS qw(LoadFile);
use Scalar::Util qw(openhandle);
use Fcntl qw(:DEFAULT);

my %config_readers = (
  xml  => sub { Bedrock::XML->new(shift) },
  json => sub { decode_json( _slurp_file(shift) ) },
  yaml => sub { LoadFile(shift) },
  yml  => sub { LoadFile(shift) },
);

########################################################################
sub _load_config {
########################################################################
  my ($file) = @_;

  my ( $ext, $filename );

  if ( openhandle($file) ) {
    # Filehandle case: Detect format and extract filename if possible
    $ext      = _detect_handle_format($file);
    $filename = _get_handle_filename($file) // '<filehandle>';
  }
  else {
    # Filename case: Locate file and extract extension
    $file     = locate_file($file);
    $filename = $file;

    if ( $file =~ /[.](xml|json|ya?ml)$/xsm ) {
      $ext = $1;
    }
    else {
      croak 'Config files must have .xml, .json, or .yaml extension';
    }
  }

  my $config = eval { $config_readers{$ext}->($file) };

  croak "Could not load config\n$EVAL_ERROR"
    if !$config;

  # Keep behavior exactly as it was—just document it properly
  $config->{_config_path} = $filename;

  return $config;
}

########################################################################
sub _slurp_file {
########################################################################
  my ($file) = @_;

  local $RS = undef;

  return <$file>
    if openhandle($file);

  # Otherwise, treat it as a filename
  open my $fh, '<', $file
    or croak sprintf q{Could not open file '%s': %s}, $file, $OS_ERROR;

  my $content = <$fh>;
  close $fh;
  return $content;
}

########################################################################
sub _detect_handle_format {
########################################################################
  my ($fh) = @_;

  my $is_data = *DATA{IO} && defined fileno($fh) && fileno($fh) == fileno \*DATA;

  my $original_pos = !$is_data ? 0 : tell $fh;

  my $peek;
  read $fh, $peek, 512;  # Read a small portion of the file

  seek $fh, $original_pos, 0;  # Restore position

  return 'json' if $peek =~ /^\s*[{[]/xsm;
  return 'xml'  if $peek =~ /^\s*<[?]?(?:xml|object)\s+/xsm;
  return 'yaml' if $peek =~ /^\s*---/xsm;

  die "Could not determine format from filehandle input\n";
}

########################################################################
sub _get_handle_filename {
########################################################################
  my ($fh) = @_;

  my $fd = fileno $fh;

  return
    if !defined $fd;

  my $is_data = *DATA{IO} && $fh == \*DATA;

  # Special case: *DATA -> use script filename
  return $PROGRAM_NAME
    if $is_data;

  # Try /proc/self/fd/ (Linux)
  if ( -d '/proc/self/fd' ) {
    my $path = readlink "/proc/self/fd/$fd";

    return $path
      if defined $path && -f $path;
  }

  # Try F_GETPATH (macOS) *only if it exists and we're on macOS*
  if ( $^O eq 'darwin' ) {
    my $path   = "\0" x 1024;                             # Allocate buffer
    my $result = eval { fcntl $fh, F_GETPATH(), $path };  # Safe eval to prevent errors

    if ($result) {
      $path =~ s/\0.*$//xsm;                              # Trim null bytes
      return $path if -f $path;
    }
  }

  return;  # Unknown or unavailable
}

########################################################################
sub locate_file {
########################################################################
  my ($file) = @_;

  # If the file exists as given, return it immediately
  return $file if -f $file;

  # Check common config directories
  for my $dir ( "/etc", "$ENV{HOME}/.config", ".", "./config" ) {
    my $path = "$dir/$file";
    return $path if -f $path;
  }

  croak "Could not locate configuration file: $file";
}

1;

