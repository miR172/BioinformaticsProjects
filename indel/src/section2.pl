#!usr/bin/perl 
use List::Util qw[min max];
use POSIX;

$file = $ARGV[0] or die; #input file name, example: hg19.panTro3
#WARNING : BEFOREUSE : CHANGE ALIGNMENT FILE FROM UCSC: TITLE LINE s/ /\t/g
####AND : EXCLUDE NOTES ON THE TOP_______________________
$n = $ARGV[1];
open IN, "../data/pair/section/$n";
@titles = <IN>;
chomp @titles;#open section file generated from step 1, many titles in
######>>>>>The idea is: to each alignment fragments, start is accurate, end should include the align but doesn't have to be accurate
open B, ">../data/pair/align/$n";#output in formate of $file,but little fragments of alignment
foreach $title(@titles){#foreach title=align section
@t = split "\t", $title;
undef $n1;undef $n2;undef $s1;undef $s2;undef @newt;
$n1 = $s1 = $t[4];
$n2 = $s2 = $t[8];
@newt = @t;
$newt[5] = $newt[4] + 200000;# not exatly where it ends, but include where it ends
$newt[9] = $newt[8] + 200000;#same as above for query sequence
$i =1;
$tmp = join "\t", @newt;
print B "$tmp\n";
open A, "../data/pair/$file";
while (<A>){
        chomp;
        next if ($. <= $t[0]);
        last if (($_ =~ /^chain/) or ($_ eq ""));
        @N = split "\t",$_;
        $n1 = $n1 + $N[0] + $N[1];
        $n2 = $n2 + $N[0] + $N[2];
        if ($n1 > $s1 + $i*100000){
                $tmp = join "\t",@N;
		print B "$tmp\n";
                $newt[4] = $n1+1;#prepare title for new ifragment
                $newt[8] = $n2+1;
                $newt[5] = $newt[4] + 200000;
                $newt[9] = $newt[8] + 200000;
                $i++;
		$tmp = join "\t",@newt;
                print B "$tmp\n";
        }
        else{
	$tmp = join "\t",@N;
        print B "$tmp\n";
        }
        }
close A;
}

close IN;
close B;

