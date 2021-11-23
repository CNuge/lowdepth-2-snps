#!/bin/bash
#SBATCH --time=0-16:00 # time (DD-HH:MM), guessing here I don't know what it'll require
#SBATCH --job-name=angsd_snp
#SBATCH --output=logs/v2_angsd_snp_parallel%J.out
#SBATCH --cpus-per-task=10
#SBATCH --mem=100G
#SBATCH --mail-type=ALL
export PATH="$PATH:$(pwd)/bin"

echo "loading the modules"
module load StdEnv/2020
module load angsd/0.933

file_path="./data/"

echo "creating list of bam files to call variants from"
ls $file_path*".realigned.bam" > "bam_file_list.txt" 
## This is the list of bam files to be processed
## Note filenames aren't created with their path, so assumes we enter the directory
## Alternatively you can comment out line 16 and provide your own list with relative imports
bam_names_file="bam_file_list.txt"

## This is the list of chromosomes to be processed by angsd, on a chromosome by chromosome basis 
## this is an absloute path b/c not in the data dir
chr_names_file="chr_names.txt" 

#specify filepath in the prefix if you want it saved to a different location than the input bamfiles
output_prefix="cunner_sex_"

out_path=$file_path"cunner_sex_analysis/"
cores=10

parallel_angsd_snp_and_gl_calling_06.sh -f $file_path -b $bam_names_file -c $cores -s $chr_names_file -o $out_path -p $output_prefix


echo "indel SNP and GL script completed!"



