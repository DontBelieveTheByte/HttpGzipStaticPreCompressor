#!/usr/bin/env perl
####
# This is a helper script to pre compress file when using the Nginx
# HttpGzipStaticModuleavailable at http://wiki.nginx.org/HttpGzipStaticModule
# Full source and documentation is available at http://github.com/DontBelieveTheByte/HttpGzipStaticPreCompressor
# Published under the GPLv3 license or later versions.
# Full license is available here : https://www.gnu.org/licenses/gpl.html
# (c) J-F B 2013
####
use Cwd 'abs_path';
use strict;
use warnings;

my $usage = "usage: nginxGzipPreProcessor.pl [-h] [SOURCE_DIR]\n" .
			"Scans SOURCE_DIR recusively, searching for files matching the extensions set in this source file\n" .
			"Options:\n" .
			"\tSOURCE_DIR\t[Optional, defaults to '.'] - Path to the root directory which would be scanned\n" .
			"\t-h --help\tPrints this message.\n";

if ($#ARGV > 0) {
	die $usage;
}

#All the file extensions we'll be compressing
my @extensions= ("css", "js", "svg", "otf", "ttf", "woff", "html", "json");

#Make sure gzip and touch are available.
if (!`which touch` || !`which gzip`){
	die "Unable to find touch or gzip commands on your system.\n";
}

#Use hard coded directory or command line argument as a starting point.
my $startDir ;
# if (defined $customDir) {
#     $startDir = $customDir;
# }
if (defined $ARGV[0]){
	if ($ARGV[0] eq "-h" || $ARGV[0] eq "--help") {
		die $usage;
	} else {
		$startDir = abs_path($ARGV[0]);
	}
} else {
	$startDir = abs_path();
}

if (!defined $startDir || !-d $startDir) {
	die "Input directory error.\n"
}

#Remove trailing slash from starting directory if present.
$startDir =~ s/(.+)\/$/$1/;

#Go to the directory we want to work with.
chdir $startDir or die "Cannot go to starting directory";
print "Starting to recusively compress files from : $startDir\n";

#Fill the directory array.
my @listOfDirs = `find -L ./ -type d`;
push(@listOfDirs, $startDir);

foreach my $currentDir (@listOfDirs){
	print "$currentDir\n";
	my $fullPathCurrentDir;
	unless ($currentDir ."/	" eq $startDir || $currentDir eq $startDir) {
		$fullPathCurrentDir = "$startDir". substr ($currentDir,1);
		print "$fullPathCurrentDir\n";
		chomp $fullPathCurrentDir;
		chdir $fullPathCurrentDir or die "Cannot change working directory to : \n$fullPathCurrentDir\n";
	}
	foreach my $exts(@extensions){
		foreach my $file (<*.$exts>){
			print "Compressing : $file\n";
			# system("gzip -9 -f -N < $file > $file.gz && touch -r $file $file.gz") == 0 or
			# die "Compression operation error at : \n" . $fullPathCurrentDir. "$file\n";
		}
	}
}
exit(0);
