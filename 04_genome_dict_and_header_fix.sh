#!/bin/bash
#SBATCH --time=0-08:00 # time (DD-HH:MM), guessing here I don't know what it'll require
#SBATCH --job-name=header_fix
#SBATCH --output=logs/v1_header_fix_%J.out
#SBATCH --cpus-per-task=10
#SBATCH --mem=100G
#SBATCH --mail-type=ALL

#add the scripts folder to the search path
export PATH="$PATH:$(pwd)/bin"

file_path="/scratch/nugentc/data/cunner_reseq/bam_files_nov10_newgenome/"
genome_file="/scratch/nugentc/bin/cunner-genome/data/raw/fTauAds1.pri.cur.20211018.fasta"


module load StdEnv/2020
module load picard/2.26.3
module load gcc/9.3.0   
module load bwa/0.7.17 #found
module load samtools/1.13

echo "indexing genome and fixing headers"
#error - its saying there is no read group information on the files, these 
# were added in step 2, but I think may have been tossed/ignored in step 3
#appears to be in the file though!
#x=$file_path"NS.1677.001.UDP0071_i7---UDP0071_i5.RKHM2019_25_.deDup.bam"
#samtools view -H $x | grep '^@RG'

#header_fix_04.sh -g $genome_file -f $file_path -c 10

header_fix_04.sh -g $genome_file -f $file_path -c 10 -r cunnerSex
