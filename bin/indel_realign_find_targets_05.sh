#!/bin/bash

while getopts g:f:c: flag
do
    case "${flag}" in
        g) genome_file=${OPTARG};;
        f) file_path=${OPTARG};;
        c) cores=${OPTARG};;
    esac
done

echo "path to the paired genome file: $genome_file";
echo "path to the paired .fq files to be processed: $file_path";
echo "number of cores being used in parallel function call: $cores";

#go to the file location
cd $file_path

#Note here I'm using the RG versions of the bam files, 
# these contain the altered headers with full read group info

# here I use the parallel pipe motif Tony had, seems more efficient than a for loop
# I think this will work - let me get both the genome variable and the bam filename in the 
# call to the genomeanalysis tool
# examples here don't use strings
echo "creating the realignment targets"
ls *RG.deDup.bam | sed 's/.deDup.bam//' | \
	parallel -j $cores \
		java -Xmx10G -jar $EBROOTGATK/GenomeAnalysisTK.jar  \
		-T RealignerTargetCreator \
		-R $genome_file \
		-I {}.deDup.bam \
		-o {}.intervals


#TODO - does this really need to be a separate script, or can it live here with the target creation?
echo "executing the realignment"
ls *RG.deDup.bam | sed 's/.deDup.bam//' | \
	parallel -j $cores \
		java -Xmx10G -jar $EBROOTGATK/GenomeAnalysisTK.jar \
		-T IndelRealigner \
		-R $genome_file \
		-I {}.deDup.bam  \
		-targetIntervals {}.intervals \
		-o {}.realigned.bam


## If that doesn't work, sub in the following
## which would start all of you jobs in parallel, then wait until they all complete before moving on. 
## In the case where you have more jobs than cores, you would start all of them and let your OS 
## scheduler worry about swapping processes in an out.
## ALSO - if it ends up going this route, I can get rid of the cores param.

#echo "creating the realignment targets"
#bam_files=$(ls *.deDup.bam | sed 's/.deDup.bam//');
#for f in $bam_files;
#do
#	infile=$f".deDup.bam"
#	outfile=$f".intervals"
#	java -Xmx6g -jar $EBROOTGATK/GenomeAnalysisTK.jar  \
#		  -T RealignerTargetCreator \
#		  -R $genome_file \
#		  -I $infile \
#		  -o $outfile &
#done


## OR if you want to still do both steps at once, sub in the following:

#echo "creating the realignment targets and conducting the realignments"
#bam_files=$(ls *.deDup.bam | sed 's/.deDup.bam//');
#for f in $bam_files;
#do
#	infile=$f".deDup.bam"
#	outfile=$f".intervals"
#   realign_file=$f".realigned.bam"
#	java -Xmx6g -jar $EBROOTGATK/GenomeAnalysisTK.jar  \
#		  -T RealignerTargetCreator \
#		  -R $genome_file \
#		  -I $infile \
#		  -o $outfile &
#
#	 java -Xmx10G -jar $EBROOTGATK/GenomeAnalysisTK.jar \
#		 -T IndelRealigner \
#		 -R $genome_file \
#		 -I $infile  \
#		 -targetIntervals $outfile \
#		 -o $realign_file
#
#done

