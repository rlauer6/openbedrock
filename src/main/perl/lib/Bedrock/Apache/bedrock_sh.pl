#!/usr/local/bin/perl -w

# ident "@(#) $Header$"
# ident "@(#)        $Name$"

use strict;
use Carp;
use File::Basename;

BEGIN
{
    my ($f, $d) = fileparse($0);
    my $inc = $d . '/bedrock.INC';
    if ( open( FILE, $inc ) ) {
	while (<FILE>) {
	    chomp;
	    if ( s/^inc\s+//i ) {
		unshift @INC, $_;
	    } elsif ( s/^config_path\s+//i ) {
		$ENV{CONFIG_PATH} = $_;
	    }
	}
	close FILE;
    }
}

use Bedrock;
use Apache::Bedrock;
use Apache::Request_shell;

$SIG{TERM} = \&confess;
$SIG{__WARN__} = \&Carp::cluck;
my $code = &Apache::Bedrock::handler( Apache::Request_shell->new );
die "Bedrock handler returned code: $code" if $code;
exit 0;

#
# Name of Release: $Name$
# $Log$
# Revision 1.1  2001/01/18 18:37:51  sridhar
# Initial release of the bedrock shell.
#
#
