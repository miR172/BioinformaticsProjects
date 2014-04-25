#!usr/bin/perl -w
use List::Util qw[min max];
use POSIX;

#only indels on reference sequence(the first one) will be calculated

$n = $ARGV[0] or die; #input file name, example: hg19.panTro3
#WARNING : BEFOREUSE : CHANGE ALIGNMENT FILE FROM UCSC: TITLE LINE s/ /\t/g
####AND : EXCLUDE NOTES ON THE TOP of $file.
open OUT, ">../data/pair/section/$n";
open IN, "../data/pair/align/$n"; 
while (<IN>){
chomp;
@a = split "\t",$_;
if ($#a > 3){ #title line
	$stop = $.;
	shift @a; # $a[0] is line number in original alignment file, we will next change it into the line number in file.n
	$tmp = join "\t",@a;
        print OUT "$stop\t$tmp\n";
	}
	else {next}
}
close OUT;
close IN;
