#!usr/bin/perl
use List::Util qw[min max];
use POSIX;

$n = $ARGV[0]; #only input: which section you want to deal with
open OUT, ">../data/pair/divergence/$n.out";
open D, "../data/pair/divergence/$n.D";
@o = <D>;
chomp @o;

foreach $record(@o){
if ( ($record =~ /chr/) or ($record =~ /LENGTH 0/) ){next}
elsif ($record =~ /LENGTH/){
	undef $s1; undef $s2;
	@r = split "\t", $record;
	foreach $i(0..$#r){
	if ($r[$i] =~ /START/){
		$s1 = $i-1;
		$s2 = $i+3;
	}else{next}
	}
	$a = join "\t", @r[1..$s1];
	$b = join "\t", @r[$s2..$#r];
	if ($a != ""){print OUT "$a\n"}
	if ($b != ""){print OUT "$b\n"}
	}
	
}
close OUT;
close D;	

open A, "../data/pair/divergence/$n.out";
@o = <A>;
chomp @o;
$nline = $#o +1;
print "number of lines: $nline\n";
$max = 1;
foreach $r(@o){
	@tmp = split "\t",$r;
	if ($max < $#tmp){$max = $#tmp+1}
	else{next}
}
close A;
print "MAX: $max\n";

system("Rscript compute1.R $n $max $nline")
