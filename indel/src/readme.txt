test.pl is record of some unsure codes, out put usually use test.out



###########################Script for indel-mutation#########
BEFORE USE: 
$mkdir section/ align/ divergence/
#store section and align fragments; divergence computing results
TIME COSTING:
-section1-|-------...-----section2----...-------|windowlize1.pl|
------------------------...--windowlize2.pl--...------------------------|


section1.pl: use on origin alignment files from UCSC, exclude notes and alter title lines(^chain) space into \t before use. 
It will generate file.section which stores the title of all alignments in the original file.
use: example:
$perl section1.pl hg19.panTro3 
# only alignment>10kb will have titles archived
# out put: hg19.panTro3.section, in section/ 1,2,...n each 4380+ lines oftitles. change the length(4380+) if necessary, in the script directly. had better no greater than 5000---> cause excess memory and job dies at interavtive nodes on hpc server. Besides, 4000+ usually takes 4h which is limit walltime on interactive
section2.pl: use on result of section1.pl. It break original file into small alignment fragments according to small piecis files in section/, thusrelief stress on compare latter. 
#Generates under align/ 1,2,...n paired with same number of title files in section/ dir.
use: example:
$perl section2.pl hg19.panTro3 n
#file and align/* share same format, while file.section and section/* share
same format. align/* and section/*: * in section/ are title lines of * in
align/ with position line in original file.


windowlize1.pl: use on result of section2
It is similar with section1.pl. Generates section/*(title files) 
i.e. we use section/* to get align/* in last step, now use aling/* to alter section/* 
use: example:
$perl windowlize1.pl hg19.panTro3 1


windowlize2.pl: use on alignment/* or original file(if the genome is really small), i.e. on any alignment file.
Argue two names of the compared species, i.e. usually the names joint with "."
in "file". also argu the n, which indicates section/* and align/* 
use:example:
$perl windowlize2.pl hg19 panTro3 1
generates: file.n.D, which stores the divergence results of aligns in file.n
#important: space between names, but not "."	also remember, file.fragments1(title lines) is based on file.1(align)
#run one at a time, DO NOT run multiple windowlize2.pl. because it's uding the tmp file in genome sequence directory, multiple using will cause tmp change and 0 - divide error!!!!!!!!!

############################IN A WORD######## WHAT WE DO HERE IS #######
original alignment	     section1.pl  file.section
between genome1 and genome2 ------------> section/*(* = 1,2...n) 
+ genome1					||
+ genome2			get align pieces|| section2.pl
						\/
					  alignment/*
						||
    alter section files(position in alignment/*)|| windowlize1.pl
						\/
					    section/*
					+ alignment/*
					+ genome sequence1
					+ genome sequence2
						||
		      compute windows Divergence|| windowlize2.pl
						\/
					   divergence/*
