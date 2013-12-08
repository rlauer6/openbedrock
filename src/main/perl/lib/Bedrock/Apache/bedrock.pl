#!/usr/bin/perl


#
#    This file is a part of Bedrock, a server-side web scripting tool.
#    Check out http://www.openbedrock.net
#    Copyright (C) 2001, Charles Jones, LLC.
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

BEGIN
{
    if ( open( FILE, 'bedrock.INC' ) ) {
	while (<FILE>) {
	    chomp;
	    if ( s/^inc\s+//i ) {
		unshift @INC, $_;
	    } elsif ( s/config_path\s+//i ) {
		$ENV{BEDROCK_CONFIG_PATH} = $_;
		$ENV{CONFIG_PATH} = $_; # deprecated
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
if ($code == 404) {
    print <<eot;
Content-type: text/html
Status: 404

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
<head>
<title>404 Not Found</title>
</head>
<body>
<h1>Not Found</h1>
<p>The requested URL $ENV{PATH_INFO} was not found on this <b>Bedrock Enabled</b> server.</p>
<hr>
<address>$ENV{SERVER_SIGNATURE}</address>
</body>
</html>
eot
}
else {
    die "Bedrock handler returned code: $code" if $code;
}

exit 0;

#
# Revision 1.5  2010/11/29 15:57:52  rlauer
# - change openbedrock.org to openbedrock.net
#
# Revision 1.4  2008/11/25 19:04:13  rlauer
# changes based on Bedrock 2.0 migration plan
#
# Revision 1.3  2001/02/14 15:35:43  sridhar
# Added copyright and GPL notice
#
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
