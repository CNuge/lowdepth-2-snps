#!/bin/bash

while getopts f:c: flag
do
    case "${flag}" in
        f) file_path=${OPTARG};;
        c) cores=${OPTARG};;
    esac
done
echo "path to the paired .fq files to be processed: $file_path";
echo "number of cores being used: $cores";

#go to the file location
cd $file_path

#this is a pipe that: 
# 1. lists all the R1 files (first member of pairs)
# 2. cuts off the R1 extension (so that the name can be reused)
# 3. makes a parallel call to cutadapt (using the number of cores alloted)
#    the outputs are named the same, but with 'trim.fastq.gz' as the extension

#setting j to 0 , auto detect cores
#is it more efficient to set it to 1, so each process gets a dedicated cpu?
ls *R1.fastq.gz | \
  sed 's/R1.fastq.gz//'| \
  parallel -j $cores 'cutadapt \
    -j 0 \
    -u 15 \
    --minimum-length 40 \
    -q 10 \
    -A CTGTCTCTTATACACA \
    -a CTGTCTCTTATACACA \
    -G GATGTGTATAAGAGACAG  \
    -g GATGTGTATAAGAGACAG \
    -o {}R1_trim.fastq.gz \
    -p {}R2_trim.fastq.gz \
    {}R1.fastq.gz \
    {}R2.fastq.gz '

## here is a one liner to double check the string going to the cutadapt call:
## use awk to print the end of the pipe with the $1 variable holding contents for each line
## the empty curly brackets hold the same thing as $1
#ls *R1.fastq.gz | sed 's/R1.fastq.gz//'| awk '{print $1"R1_trim.fastq.gz "$1"R2_trim.fastq.gz "'$cores'"EOL"}'

