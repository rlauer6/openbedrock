#!/usr/local/bin/perl -w

# ident "@(#) $Header$"
# ident "@(#)        $Name$"

BEGIN
{
    if ( open( FILE, 'bedrock.INC' ) ) {
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

use strict;
use Carp;

use Bedrock;
use Apache::Bedrock;
use Apache::Request_cgi;

$SIG{TERM} = \&confess;
$SIG{__WARN__} = \&Carp::cluck;
my $code = &Apache::Bedrock::handler( Apache::Request_cgi->new );
die "Bedrock handler returned code: $code" if $code;
exit 0;

#
# Name of Release: $Name$
# $Log$
# Revision 1.2  2001/01/18 18:38:57  sridhar
# Included a hack for specifying the required Perl include path and
# CONFIG_PATH in a file `bedrock.INC' in the current dir.
#
# Revision 1.1  2000/12/18 15:07:49  sridhar
# Moved bedrock.cgi to bedrock.pl since new make rule added to properly
# build .cgi from .pl
#
# Revision 1.1  2000/12/12 18:54:46  sridhar
# The CGI version of Bedrock; uses the mod_perl handler by setting up an
# apache-request-like object.
#
#
