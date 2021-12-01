#!/bin/bash

while getopts g:f:c:o: flag
do
    case "${flag}" in
        g) genome_file=${OPTARG};;
        f) file_path=${OPTARG};;
        c) cores=${OPTARG};;
		o) outfolder=${OPTARG};;
    esac
done

echo "path to the paired genome file: $genome_file";
echo "path to the paired .fq files to be processed: $file_path";
echo "number of cores being used: $cores";
echo "writing outputs to folder: $outfolder"

if [ ! -d $outfolder ]; then
  mkdir -p $outfolder;
fi

bwa index $genome_file

#go to the file location
cd $file_path


# looks like tony has a file with the samples stored... I'll keep with his first motif as I like it better
# this gets the TOcDO list for alignment, finds the first member of the trimmed paired read files, 
# and builds up 
trim_files=$(ls *R1_trim.fastq.gz | sed 's/_R1_trim.fastq.gz//');


for f in $trim_files
do
	echo "on file set:"
	echo $f
	r1=$f"_R1_trim.fastq.gz"; # the R1 read file
	r2=$f"_R2_trim.fastq.gz"; # the R2 read file name

	bam_outfile=$outfolder$f".bam";	 # the name of the .bam output
	bam_sorted_outfile=$outfolder$f".sorted.bam";	 # the name of the .bam output
	header_line="@RG\tID:$f\tSM:$fe\tLB:AOM_Cunner"; #need to generalize this, a header added to sam file
	#^this line causing problems later, the SM is getting removed.
	#I think the addition of the header line should be removed.

	echo "saving data to file"
	echo $bam_outfile

	#burrows wheeler mem alignment to reference genome and output sorting with samtools
	bwa mem -t $cores -R $header_line $genome_file $r1 $r2 | samtools view -bS - > $bam_outfile

	samtools sort $bam_outfile -o $bam_sorted_outfile -T $f -@ $cores -m 3G;
	#bwa mem
	#-t #threads
	#-R #read group header line, way of specifying the individual of origin
	#samtools
	#@T gives number of threads, -m 3G gives the maximum mempry per thread (currently hardcoded, increase)

done