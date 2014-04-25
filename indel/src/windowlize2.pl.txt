#!usr/bin/perl 
use List::Util qw[min max];
use POSIX;
###############################FUNCTION>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
###############################FUNCTION>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
###############################FUNCTION>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
sub get_seq { #get sequence of the alignments
        my @yqh = @_;#input:
##species chr   start sl  end  el##
##   0     1     2    3    4   5 ##
open MY, "../data/$yqh[0]/$yqh[1]" or return ""; #arguments are $genome{$species}{$chr}, input CHR!!!!
open TMP, ">../data/$yqh[0]/tmp";#store the compare sequence in tmp file     
        my $sl = $yqh[3];
        my $el = $yqh[5];
        my $s = $yqh[2] - ($sl-1)*50 - 1 ;
        my $e = $yqh[4] - ($el-1)*50 - 1 ;
        my @sequence = <MY>;
        chomp @sequence;
        my $primary1 = $sequence[$sl];
        my $primary2 = $sequence[$el];
	
	my @tmp = split "",$primary1;
	my @pri1 = @tmp[$s..$#tmp];
	my $p1 = join "\n",@pri1;#primary 1
	
	@tmp = split "",$primary2;
	my @pri2 = @tmp[0..$e];
	my $p2 = join "\n",@pri2;#primary 2
	
	print TMP "$p1\n";
	close MY;
open MY, "../data/$yqh[0]/$yqh[1]";
	my $n = 0;
	while (<MY>){
	chomp;
        next if ($. <= $yqh[3]);#yqh3 is start line
        last if ($. >= $yqh[5]);#yqh5 is end line
        @tmp =split "",$_;
        my $oo = join "\n",@tmp;
        print TMP "$oo\n";
	}
close MY;
print TMP "$p2\n";
close TMP;
my $dir = "../data/$yqh[0]/tmp";
return ($dir);
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sub locate{ #locate windows on GOTTEN sequence from above two functions!
#imput: tmp file of alinged sequence:dir, +-, interval start, interval end
  my $dir = $_[0];
  my $strand = $_[1];
  my $from = $_[2];
  my $to = $_[3]-1;
open D,$dir;
my @seq = <D>;
chomp @seq;
@love = @seq[$from..$to];
@new = @love;
if ( $strand eq "-"){
	foreach $w(0..$#l){
        if ($love[$w] eq "a"){ $new[$w] = "t"}
        if ($love[$w] eq "t"){ $new[$w] = "a"}
        if ($love[$w] eq "c"){ $new[$w] = "g"}
        if ($love[$w] eq "g"){ $new[$w] = "c"}
        if ($love[$w] eq "A"){ $new[$w] = "T"}
        if ($love[$w] eq "T"){ $new[$w] = "A"}
        if ($love[$w] eq "C"){ $new[$w] = "G"}
        if ($love[$w] eq "G"){ $new[$w] = "C"}
        }
}
$be = join "",@new;
close D;
return $be;
}#return sequence as $,

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub disi{ #compare descrete between, count, divide by length====>origin Divergence
 #imput:two sequences,two $
 my $same = 0;
 my @a = split "", $_[0];
 my @b = split "", $_[1];
 my $same = 0; 
foreach $I(0..$#b){
        $A = uc($b[$I]);
        $B = uc($a[$I]);
        if ($A eq $B){
        $same++;
        }
        else{next}
}
if ($#b+1 eq 0){return "NA"}
else{
$d = 1- ($same/($#b+1));
$d = sprintf "%e", $d;
 return $d;
}}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub newport{# imput: p0 p1 p2 p3      n0 n1 n2
	my @P = @_;
	$P[0] = $P[1] = $P[1]+$P[5];
        $P[2] = $P[3] = $P[3]+$P[6];
	@P = @P[0..3];
return @P;
}
###############################FUNCTION>>>>>>>>>>>>>>>>END
###############################FUNCITON>>>>>>>>>>>>>>>>END
###############################FUNCTION>>>>>>>>>>>>>>>>END

#only indels on reference sequence(the first one) will be calculated
@name = @ARGV or die; #input: genome1 genome2 n
$n = $name[2];
print "compare: $name[0] VS $name[1]\n"; #just to check
open A, "../data/pair/section/$n";#tells you where section titles are 
@aligns = <A>;
chomp @aligns;
open B, ">>../data/pair/divergence/$n.D";
foreach $align(@aligns){
	print "$align\n";
#0			1	  2   3   4    5   6   7   8   9  ##
#line in alinfile, alingment ID, chr +- start end chr +- start end##
	@a = split "\t",$align;
	print B "\n@a\n";
	$sl = ceil($a[4]/50);#startline
	$el = ceil($a[5]/50);#endline
	$dir[1] = get_seq($name[0],$a[2],$a[4],$sl,$a[5],$el);
	$sl = ceil($a[8]/50);#start line 
	$el = ceil($a[9]/50); #end line
	$dir[2] = get_seq($name[1],$a[6],$a[8],$sl,$a[9],$el);	
	if (($dir[1] eq "") or ($dir[2] eq "")){next}
	else{
	@p = (0,0,0,0);
	open C, "../data/pair/align/$n"; #alignment file
	while (<C>){
	chomp;
	next if($. <= $a[0]);
	last if($_ =~ /chr/);
		@N = split "\t",$_;
		$p[1] = $p[1] + $N[0];
        	$p[3] = $p[3] + $N[0];	
		undef @l;undef @r;
		$i = 1;
		$strand[1] = $a[3];
		$strand[2] = $a[7];
		print "intervals: $p[0]_$p[1]\tVS\t$p[2]_$p[3]\n";
		if ($N[0] < 100){
			$w0 = disi(locate($dir[1],$strand[1],$p[0],$p[1]),locate($dir[2],$strand[2],$p[2],$p[3]));
                	$tmp = $p[1]+1;
                	print B "w0\t$w0\nw0\t$w0\tSTART $tmp\tLENGTH $N[1]\t"; #\t end add right windows: belongs to next line, name"L0..Ln"
			}
		if ($N[0] >= 100){
			$l[0] = disi(locate($dir[1],$strand[1],$p[0],$p[0]+50), locate($dir[2],$strand[2],$p[2],$p[2]+50));
			$r[0] = disi(locate($dir[1],$strand[1],$p[1]-50,$p[1]), locate($dir[2],$strand[2],$p[3]-50,$p[3]));
			$mi[1] = ceil(($p[1]+$p[0])/2); #middle of interval on reference seq 
			$mi[2] = ceil(($p[2]+$p[3])/2); #middle point on query seq
			while ( ($p[0]+50+$i*100) < ($mi[1]+50) ){#a.l.a the end of this=start of next::  less than middle+50
				$l[$i] = disi( locate($dir[1], $strand[1],$p[0]+50+($i-1)*100, $p[0]+50+$i*100), locate($dir[2], $strand[2],$p[2]+50+($i-1)*100, $p[2]+50+$i*100) );
				$r[$i] = disi( locate($dir[1],$strand[1], $p[1]-50-$i*100, $p[1]-50-($i-1)*100), locate($dir[2], $strand[2],$p[3]-50-$i*100, $p[3]-50-($i-1)*100) );	
				$i++;
			}
			$i = $i-1;#check last valid round,where is the window:
			if ( ($p[0]+50+$i*100) <= $mi[1]){ #the end of last validate is less than middle
				$l[$i] = disi( locate($dir[1],$strand[1], $p[0]+50+($i-1)*100, $mi[1]), locate($dir[2],$strand[2], $p[2]+50+($i-1)*100, $mi[2]) );#alter last validate: start-no change, end-to middlesite
				$r[$i] = disi( locate($dir[1], $strand[1],$mi[1],$p[1]-50-($i-1)*100), locate($dir[2],$strand[2], $mi[2], $p[3]-50-($i-1)*100) );	
			}
			if ( ($p[0]+50+$i*100) > $mi[1]){ #the end of last validate is more than middle
				$l[$i] = disi( locate($dir[1],$strand[1], $p[0]+50+($i-1)*100, $p[1]-50-($i-1)*100), locate($dir[2], $strand[2], $p[2]+50+($i-1)*100, $p[3]-50-($i-1)*100) );
				$r[$i] = disi( locate($dir[1],$strand[1], $p[0]+50+($i-1)*100, $p[1]-50-($i-1)*100), locate($dir[2], $strand[2], $p[2]+50+($i-1)*100, $p[3]-50-($i-1)*100) );
			}
			$tmp = $p[1]+1;
			$L = join "\t", @l;
			$R = join "\t", @r;
			print B "L0..L$#l\t$L\nR0..R$#r\t$R\tSTART $tmp\tLENGTH $N[1]\t";
			}
		@p = newport(@p,@N);
		} 
	close C;
}}
close A;
close B;


