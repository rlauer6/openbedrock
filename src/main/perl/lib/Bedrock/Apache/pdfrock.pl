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
use IO;
use POSIX;
use File::Basename;

use SIS::Base;
use SIS::Log;
use Text::TagX;
use PDF::Handle;

#
# Routine sends content back to client
# Invoked as content($dataref)
#     where $dataref is a reference to the PDF data
#
sub show_pdf
{
    my $dataref = shift;
    print "Accept-ranges: bytes\nContent-type: application/pdf\nContent-length: ", length($$dataref), "\n\n";
    print($$dataref);
    exit 0;
}

######################################################################
#                                                                    #
#                     MAIN PROGRAM STARTS FROM HERE                  #
#                                                                    #
######################################################################

#
# Start the program
#
$SIG{TERM} = \&confess;
my $cgi = new SIS::Base ('CONFIG_FILE' => 'pdfrock.cfg');

#
# Determine filename to process based on request
#
my $file;
LOG_MESSAGE( MSG_QUIT( MSG_ERROR ), "PATH_TRANSLATED is not set." )
    unless exists $ENV{'PATH_TRANSLATED'} and $file = $ENV{'PATH_TRANSLATED'};

if ( -e $file ) {
    LOG_MESSAGE( MSG_QUIT( MSG_SYSERROR ), "Unable to open $file" )
	unless open( INPUT, $file );

    local($/) = undef;
    my $data = <INPUT>;
    close INPUT;

    &show_pdf(\$data);
    exit 0;
}

# We look at file extensions in the following order: .txt, ''(no ext), .roc
my ($base, $dir, $suf) = fileparse( $file, "\.pdf");
my $nosuffix = $dir . $base;
my $txtfile = $nosuffix . ".txt";
my $rocfile = $nosuffix . ".roc";
my ($type, $source) = do {
    if		( -e $nosuffix )	{('txt', $nosuffix)}
    elsif	( -e $txtfile )		{('txt', $txtfile)}
    elsif	( -e $rocfile )		{('roc', $rocfile)}
    else {
	LOG_MESSAGE( MSG_QUIT( MSG_ERROR ), "File does exist: $file" );
    }
};

# Construct output handle
my $outh = PDF::Handle->new;

# Construct context object
my $ctx = SIS::Base->new ('CONFIG_FILE' => 'pdfrock.cfg',
			  'OUTPUT_HANDLE' => $outh);

# Set options for pdf
my $format = $ctx->getConfigValue('page_format');
$outh->setOptions($format) if defined($format);

# Text handler if doing only text.
if ( $type eq 'txt' ) {
    LOG_MESSAGE( MSG_QUIT( MSG_SYSERROR ), "Unable to open $source" )
	unless open( INPUT, $file );

    while (<INPUT>) {
	$outh->print($_);
    }
    close INPUT;

    &show_pdf($outh->close);
    exit 0;
}

my $tx = Text::TagX->new ($source, $outh);

#
# Set logging parameters
#
my $f = ($ctx->getConfigValue ('HTML_LOGDIR') || $ctx->getConfigValue( 'LOGDIR' ) || '/tmp')
    . '/' . $base . ".roc";
my $sz = $ctx->getConfigValue('HTML_LOGMAXSIZE') || $ctx->getConfigValue ('LOG_MAXSIZE') || 200000;
$tx->options(LOG_PREFIX =>  $f, LOG_MAXSIZE => $sz);

#
# Load Startup BLMs
#
my $modules = $ctx->getConfigValue('MODULES');
if ( $modules and $modules->{'STARTUP'} ) {
    my %startup = %{$modules->{'STARTUP'}};
    for my $nametag (keys %startup) {
	my $href = bless {}, $startup{$nametag};
	tie %{$href}, $startup{$nametag}, $ctx;
	$startup{$nametag} = $href;
	$tx->param( $nametag, $href );
    }
}

# Additional module to invoke PDF methods on
$tx->param( 'pdf' => $outh );

eval { $tx->output };
$tx->close;
if ( $@ ) {
    LOG_MESSAGE( MSG_QUIT( MSG_ERROR ), "Script $file encountered the following error\n    $@" );
} else {
    # Show the output
    &show_pdf($outh->close);
    exit 0;
}

#
# Name of Release: $Name$
# $Log$
# Revision 1.1  2000/12/18 18:03:47  sridhar
# 1. Moved Perl/apps/PDFrock/PDFrock.pl to Bedrock/Apache/pdfrock.pl
# 2. Probably doesn't work yet
#
# Revision 1.2  2000/12/15 19:02:37  sridhar
# Kicked out BLM::Startup::Modules.
#
# Revision 1.1  2000/09/27 15:32:42  sridhar
# The CGI version of PDFrock
#
#
