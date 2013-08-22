#!/usr/bin/env perl
####
# This is a helper script to pre compress file when using the Nginx 
# HttpGzipStaticModuleavailable at http://wiki.nginx.org/HttpGzipStaticModule
# Full source and documentation is available at http://github.com/DontBelieveTheByte/HttpGzipStaticPreCompressor
# Published under the GPLv3 license or later versions.
# Full license is available here : https://www.gnu.org/licenses/gpl.html
# (c) J-F B 2013
####
use Cwd;
use strict;
use warnings;

#All the file extensions we'll be compressing
my @extensions= ("css", "js", "svg", "otf", "ttf", "woff");

#Uncomment to set a hard coded directory.
my $customDir = '/usr/share/nginx/';

#Make sure gzip and touch are available.
if (!`which touch` || !`which gzip`){
    die "Unable to find touch or gzip commands on your system.\n";
}

#Use hard coded directory or command line argument as a starting point.
my $startDir ;
if (defined $customDir) {
    $startDir = $customDir;
}
if (defined $ARGV[1]){
    $startDir = $ARGV[1];
}
if (!defined $startDir || !-d $startDir) {
    die "Input directory error.\n"
}
#Remove trailing slash from starting directory if present.
$startDir =~ s/(.+)\/$/$1/;

#Go to the directory we want to work with.
chdir $startDir or die "Cannot go to starting directort";
print "Starting to recusively compress files from : $startDir\n";

#Fill the directory array.
my @listOfDirs = `find -L ./ -type d`;
push(@listOfDirs, $startDir);

foreach my $currentDir (@listOfDirs){
    #print "$currentDir\n";
        my $fullPathCurrentDir;
        unless ($currentDir ."/	" eq $startDir || $currentDir eq $startDir){
	    $fullPathCurrentDir = "$startDir". substr ($currentDir,1);
            print "$fullPathCurrentDir\n";
            chomp $fullPathCurrentDir;
            chdir $fullPathCurrentDir or die "Cannot change working directory to : \n$fullPathCurrentDir\n";
        }
        foreach my $exts(@extensions){
            foreach my $file (<*.$exts>){
            print "Compressing : $file\n";
            system("gzip -9 -f -N < $file > $file.gz && touch -r $file $file.gz") == 0 or
            die "Compression operation error at : \n" . $fullPathCurrentDir. "$file\n";
            }
        }	
}
exit(0);
