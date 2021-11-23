#!/bin/bash
#SBATCH --time=0-08:00 # time (DD-HH:MM), guessing here I don't know what it'll require
#SBATCH --job-name=header_fix
#SBATCH --output=logs/v1_header_fix_%J.out
#SBATCH --cpus-per-task=10
#SBATCH --mem=100G
#SBATCH --mail-type=ALL

#add the scripts folder to the search path
export PATH="$PATH:$(pwd)/bin"

file_path="./data/"
#your genome file here!
genome_file="./data/fTauAds1.pri.cur.20211018.fasta"
#make this equal to the cpus-per-task argument given to sbatch on line 5
cores=10
#the batch id added to the header
read_group_name="cunner_example_batch"


echo "loading the modules"
module load StdEnv/2020
module load picard/2.26.3
module load gcc/9.3.0   
module load bwa/0.7.17 #found
module load samtools/1.13

echo "indexing genome and fixing headers"
header_fix_04.sh -g $genome_file -f $file_path -c $cores -r $read_group_name
