#!/usr/local/bin/perl -w

# ident "@(#) $Header$"
# ident "@(#)        $Name$"

BEGIN
{
    if ( open( FILE, 'perl.INC' ) ) {
	unshift @INC, <FILE>;
	close FILE;
	chomp @INC;
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
# Revision 1.1  2000/12/18 15:07:49  sridhar
# Moved bedrock.cgi to bedrock.pl since new make rule added to properly
# build .cgi from .pl
#
# Revision 1.1  2000/12/12 18:54:46  sridhar
# The CGI version of Bedrock; uses the mod_perl handler by setting up an
# apache-request-like object.
#
#
