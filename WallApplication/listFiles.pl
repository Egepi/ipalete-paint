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

my $saveFile = "theFiles.fil";

chdir ( "/home/crazyprofessor/sketchbook/WallApplication" );
system ( "rm $saveFile" );
system ( "ls -1 > $saveFile" );

exit;

