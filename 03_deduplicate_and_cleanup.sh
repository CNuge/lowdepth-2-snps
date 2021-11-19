#!/bin/bash
#SBATCH --time=0-08:00 # time (DD-HH:MM)
#SBATCH --job-name=parallel_bam_dedup
#SBATCH --output=logs/v1_bam_dedup_and_cleanup_%J.out
#SBATCH --cpus-per-task=10
#SBATCH --mail-type=ALL
#SBATCH --mem=101G

#add the scripts folder to the search path
export PATH="$PATH:$(pwd)/bin"

echo "loading necessary modules"
module load StdEnv/2020  
module load gcc/9.3.0   
module load bwa/0.7.17 #found
module load samtools/1.13
module load picard/2.26.3
module load bamtools/2.5.1


file_path="/scratch/nugentc/data/cunner_reseq/bam_files_nov10_newgenome/"

bam_dedup_03.sh -f $file_path -c 10

echo "bam dedup and cleanup script completed!"


