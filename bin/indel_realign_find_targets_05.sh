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

# Note here I'm using the RG versions of the bam files, 
# these contain the altered headers with full read group info

echo "creating the realignment targets"
ls *RG.deDup.bam | sed 's/.deDup.bam//' | \
	parallel -j $cores \
		java -Xmx10G -jar $EBROOTGATK/GenomeAnalysisTK.jar  \
		-T RealignerTargetCreator \
		-R $genome_file \
		-I {}.deDup.bam \
		-o {}.intervals


echo "executing the realignment"
ls *RG.deDup.bam | sed 's/.deDup.bam//' | \
	parallel -j $cores \
		java -Xmx10G -jar $EBROOTGATK/GenomeAnalysisTK.jar \
		-T IndelRealigner \
		-R $genome_file \
		-I {}.deDup.bam  \
		-targetIntervals {}.intervals \
		-o {}.realigned.bam

