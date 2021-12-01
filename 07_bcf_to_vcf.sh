#!/bin/bash
#SBATCH --time=0-02:00 # time (DD-HH:MM), guessing here I don't know what it'll require
#SBATCH --job-name=bcf_to_vcf
#SBATCH --output=logs/bcf_to_vcf_%J.out
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=ALL

export PATH="$PATH:$(pwd)/bin"

echo "loading modules"
module load StdEnv/2020  
module load gcc/9.3.0 
module load bcftools/1.13 

echo "setting params"
file_path="$(pwd)/data/"

echo "calling shell script"
bcf_to_vcf_07.sh -f $file_path 

echo "bcf to vcf conversion completed!"