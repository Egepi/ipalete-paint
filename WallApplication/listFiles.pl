#/usr/bin/perl
#----------------------------------------------------------
# Author: Todd Silvia
# Script: listFiles.pl
# Date: 9/27/2010
# Description: Perl script to scan a given folder for all
#   files inside it and place the list of files into text
#   file for reading in by the wall app.
#----------------------------------------------------------
#################################
# Need to account of rm save file if it is already gone
#################################

use warnings;
use strict;

my $argSize = @ARGV;
if($argSize < 1) {
	print "No folder path found";
}

my $saveFile = "theFiles.fil";
my $imgDir = $ARGV[0];

chdir ( "$imgDir" );
system ( "rm $saveFile" );
system ( "ls -1 > ../../$saveFile" );

exit;

