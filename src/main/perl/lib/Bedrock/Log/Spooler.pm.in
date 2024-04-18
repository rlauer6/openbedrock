package Bedrock::Log::Spooler;

#
#    This file is a part of Bedrock, a server-side web scripting tool.
#    Check out http://www.openbedrock.net
#    Copyright (C) 2024, TBC Development Group, LLC.
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

use strict;
use warnings;

use base qw(Class::Singleton);

use Bedrock::Constants qw(:chars :booleans);

use Data::Dumper;
use Carp;
use Redis;

use JSON -convert_blessed_universally;

########################################################################
sub _new_instance {
########################################################################
  my ( $class, @args ) = @_;

  my $self = ref $args[0] ? $args[0] : {@args};

  bless $self, $class;

  if ( !$self->channel ) {
    $self->channel('bedrock/log');
  }

  if ( !$self->server ) {
    $self->server('localhost');
  }

  if ( !$self->port ) {
    $self->port('6379');
  }

  $self->publish_env( $self->publish_env // $FALSE );

  my $host = sprintf '%s:%s', $self->server, $self->port;

  my $redis_client = Redis->new( server => $host )
    or croak sprintf 'Cannot connect to Redis host: %s', $host;

  $self->redis_client($redis_client);

  return $self;
}

########################################################################
sub publish {
########################################################################
  my ( $self, $log_message, %details ) = @_;

  my $env = q{};

  if ( $self->publish_env ) {
    $env = to_json( \%ENV, { allow_blessed => $TRUE, convert_blessed => $TRUE } );
  }

  my %payload = (
    %details,
    env     => $env,
    time    => time,
    message => join $EMPTY,
    @{$log_message},
  );

  my $channel = $payload{channel} || $self->channel;

  return $self->redis_client->publish( $channel,
    to_json( \%payload, { allow_blessed => $TRUE, convert_blessed => $TRUE } ) );
}

{
  ## no critic (RequireArgUnpacking)

  sub redis_client { unshift @_, 'redis_client'; goto &_set_get; }
  sub publish_env  { unshift @_, 'publish_env';  goto &_set_get; }
  sub channel      { unshift @_, 'channel';      goto &_set_get; }
  sub server       { unshift @_, 'server';       goto &_set_get; }
  sub port         { unshift @_, 'port';         goto &_set_get; }
}

# _set_get(key, self, value);

########################################################################
sub _set_get {
########################################################################
  my ( $key, @args ) = @_;

  if ( @args > 1 ) {
    $args[0]->{$key} = $args[1];
  }

  return $args[0]->{$key};
}

1;

## no critic (RequirePodSections)

__END__

=pod

=head1 NAME

Bedrock::Log::Spooler - Log spooler

=head1 SYNOPSIS

 my $spooler = Bedrock::Log::Spooler->new;
 $spooler->publish("some message...", key => value, ...);

=head1 DESCRIPTION

Singleton class for spooling logging information to a Redis channel.
Suppose you want to aggregate logs from several servers or provide
addtional information that could "potentially" be captured from your
application.

C<Bedrock::Log::Spooler> can help you publish information to a Redis
channel by adding a call to the C<publish()> method at various points
in your logger or application.  Then, use a subscriber to receive,
filter and capture the published events.

   my $redis = Redis(server => 'localhost:6379')->new;

   $redis->psubscribe('foo*', sub { print Dumper [@_] });

   $redis->wait_for_messages(10) while $keep_going;

=head2 redis_client

Set or get the Redis client handle.

=head2 publish_env

Set or get an indicator that determines if C<%ENV> should be published
to channel. You may not want to publish C<%ENV> if it contains
sensitive information.

 $spooler->publish_env(1);

default: false

=head2 channel

Name of the channel to publish messages to.

=head2 server

Server name or IP address of Redis server.

=head2 port

Port that Redis server is listening on.

=head2 publish

 publish(message, key => value, ...)

Publish a message and addition information to a Redis channel.

=head1 AUTHOR

Rob Lauer - <bigfoot@cpan.org>

=cut
