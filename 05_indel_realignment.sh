#!/bin/bash
#SBATCH --time=0-08:00 # time (DD-HH:MM), guessing here I don't know what it'll require
#SBATCH --job-name=indel_realign_target
#SBATCH --output=logs/v1_indel_realign_full_%J.out
#SBATCH --cpus-per-task=10
#SBATCH --mem=100G
#SBATCH --mail-type=ALL

#add the scripts folder to the search path
export PATH="$PATH:$(pwd)/bin"

file_path="/scratch/nugentc/data/cunner_reseq/bam_files_nov10_newgenome/"
genome_file="/scratch/nugentc/bin/cunner-genome/data/raw/fTauAds1.pri.cur.20211018.fasta"


module load StdEnv/2020
module load picard/2.26.3

#note tony used version 3.7, I'm copying as per his suggestions
#apparently this step may be redundant with the 4.* workflow, leaving for now
module load nixpkgs/16.09   
module load gatk/3.8 

echo "run the alignments"
indel_realign_find_targets_05.sh -g $genome_file -f $file_path -c 10

echo "indel target script completed!"
