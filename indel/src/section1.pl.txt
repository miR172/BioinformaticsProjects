#!usr/bin/perl -w
use List::Util qw[min max];
use POSIX;

#only indels on reference sequence(the first one) will be calculated

$file = $ARGV[0] or die; #input file name, example: hg19.panTro3
#WARNING : BEFOREUSE : CHANGE ALIGNMENT FILE FROM UCSC: TITLE LINE s/ /\t/g
####AND : EXCLUDE NOTES ON THE TOP_______________________>

open OUT, ">../data/pair/$file.section";
open IN, "../data/pair/$file"; 
while (<IN>){
chomp;
if ($_ =~ /^chain/){ #title line of each alignment section, format:
	$stop = $.;
	@a = split "\t", $_; #score X t(chrName chrSize Strand Start End) q(chrName chrSize Strand Start End) alignment_chainID
        if($a[6] > $a[5]+10000){ #only pick align>10kb
	$print = pop @a;
        @a = @a[2,4..7,9..11];
	##lineinAlignfile,AlignID; 0,1
        ## 2    3   4  5    6    7 ##
	##chr +- start end chr +- start end##
	$tmp = join "\t",@a;
        print OUT "$stop\t$print\t$tmp\n";
	}
	else {next}
}
else{next}
}
close OUT;
close IN;

open IN, "../data/pair/$file.section";
@titles = <IN>;
chomp @titles;
$max = floor(($#titles+1)/4589);
for $i(0..$max){
        $I =$i+1;
        open OUT, ">../data/pair/section/$I";
        $start = $i*4589;
        $end = ($i+1)*4589-1;
        if($end > $#titles){$end = $#titles}
        foreach $title(@titles[$start..$end]){
                print OUT "$title\n";
        }
        close OUT;
        }
close IN;

print "generates: $I pieces of section files under section/\n";
