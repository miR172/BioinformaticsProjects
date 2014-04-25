open A, "../data/pair/hg19.panTro3";
while (<A>){
chomp;
if ($_ =~ /^chain/){
$n++;
@a = split "\t",$_;
if ($a[6] < $a[5]+10000) {
$m++;
}
}
}

close A;
print "there are $n alignments.\n$m of them <10kb\n";
