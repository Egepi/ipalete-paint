#/usr/bin/perl
#----------------------------------------------------------
# Author: Todd Silvia
# Script: listFiles.pl
# Date: 9/27/2010
# Description: Perl script to scan a given folder for all
#   files inside it and place the list of files into text
#   file for reading in by the wall app.
#----------------------------------------------------------

use warnings;
use strict;

#print "Hello\n";
chdir ( "/home/crazyprofessor/sketchbook/WallApplication");
system ( "ls -1 > theFiles.fil" );

exit;

