#!/bin/bash
#SBATCH --time=3-00:00 # time (DD-HH:MM)
#SBATCH --job-name=bwa_mem_v_genome
#SBATCH --output=logs/v2_bwa_mem_v_genome_%J.out
#SBATCH --cpus-per-task=32
#SBATCH --mem=125G
#SBATCH --mail-type=ALL

#add the scripts folder to the search path
export PATH="$PATH:$(pwd)/bin"

echo "loading necessary modules"
module load StdEnv/2020  
module load gcc/9.3.0   
module load bwa/0.7.17 
module load samtools/1.13

echo "new genome being used!"
#location of the reference genome to align to
#your genome file here!
genome_file="./data/fTauAds1.pri.cur.20211018.fasta"
#location of the paired end cutadapt outputs, labelled in the format "*R*_trim.fastq.gz"
file_path="$(pwd)/data/"
#location where the alignment outputs should be saved to (in sorted bam format)
#by default to a subfolder in original data directory with name bamfiles/
outfolder="$(pwd)/data/"

cores=32 #make this equal to the cpus-per-task argument given to sbatch on line 5

#match -c to the --cpus-per-task in the SBATCH header
bwa_mem_vs_genome_02.sh -g $genome_file -f $file_path -c $cores -o $outfolder

echo "bwa alignment script completed!"
