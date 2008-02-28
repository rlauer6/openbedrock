#!/usr/bin/perl -w

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
# Revision 1.1  2008/02/28 20:15:57  rlauer
# - re-adding file bedrock.cgi from trunk
#
# Revision 1.3  2008/02/28 13:11:08  alans
# Adding bedrock.cgi file from the 1.6.4 tarball for the purposes of tagging
# a representation of the 1.6.4 codebase in CVS
#
# Revision 1.1  2000/12/12 18:54:46  sridhar
# The CGI version of Bedrock; uses the mod_perl handler by setting up an
# apache-request-like object.
#
#
