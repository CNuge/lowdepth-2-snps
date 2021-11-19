#!/bin/bash
#SBATCH --time=0-16:00 # time (DD-HH:MM), guessing here I don't know what it'll require
#SBATCH --job-name=angsd_snp
#SBATCH --output=logs/v2_angsd_snp_parallel%J.out
#SBATCH --cpus-per-task=10
#SBATCH --mem=100G
#SBATCH --mail-type=ALL
export PATH="$PATH:$(pwd)/bin"

module load StdEnv/2020
module load angsd/0.933

data_path="/scratch/nugentc/data/cunner_reseq/bam_files_nov10_newgenome/"

ls $data_path*".realigned.bam" > "bam_file_list.txt" #need to test this line
#note filenames aren't with their path, so assumes we enter the directory

#this is the list of chromosomes to be processed by angsd, on a chromosome by chromosome basis 
#this is an absloute path b/c not in the data dir
echo "may want to change this to the NCBI names once curated NCBI version available"
chr_names_file="/scratch/nugentc/bin/cunner-genome/scripts/individual_resequencing/cunner_chr_names.txt" 
#this is the list of bam files to be processed
bam_names_file="/scratch/nugentc/bin/cunner-genome/scripts/individual_resequencing/bam_file_list.txt"

#specify filepath in the prefix if you want it saved to a different location than the input bamfiles
output_prefix="cunner_sex_"

out_path=$data_path"cunner_sex_analysis/"


parallel_angsd_snp_and_gl_calling_06.sh -f $data_path -b $bam_names_file -c 10 -s $chr_names_file -o $out_path -p $output_prefix


echo "indel SNP and GL script completed!"



