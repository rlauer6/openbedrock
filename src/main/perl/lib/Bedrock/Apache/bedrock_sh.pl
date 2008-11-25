#!/usr/local/bin/perl -w

# ident "@(#) $Header$"
# ident "@(#)        $Name$"

#
#    This file is a part of Bedrock, a server-side web scripting tool.
#    Check out http://www.openbedrock.org
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
	    } elsif ( s/config_path\s+//i ) {
		$ENV{BEDROCK_CONFIG_PATH} = $_;
		$ENV{CONFIG_PATH} = $_; # deprecated
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
# Revision 1.3  2008/11/25 19:04:13  rlauer
# changes based on Bedrock 2.0 migration plan
#
# Revision 1.2  2001/02/14 15:35:43  sridhar
# Added copyright and GPL notice
#
# Revision 1.1  2001/01/18 18:37:51  sridhar
# Initial release of the bedrock shell.
#
#
