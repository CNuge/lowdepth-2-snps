#!/bin/bash
#SBATCH --time=3-00:00 # time (DD-HH:MM)
#SBATCH --job-name=cutadapt_paired_reads
#SBATCH --output=logs/v1_cutadpat_run_%J.out
#SBATCH --cpus-per-task=4
#SBATCH --mem=125G
#SBATCH --mail-type=ALL

#add the scripts folder to the search path
export PATH="$PATH:$(pwd)/bin"

echo "loading the virtual python environment"
#this one is a bit of a mess because cutadapt must be built in a python venv
module load python/3.8
virtualenv --no-download $SLURM_TMPDIR/env
source $SLURM_TMPDIR/env/bin/activate
python3 -m pip install cutadapt


echo "getting input variables"
file_path="./data/"
echo "reading data from:"
echo $data_path

cores=4 #make this equal to the cpus-per-task argument given to sbatch on line 5
echo "number of cores being used:"
echo $cores

echo "running cutadapt script"
cutadapt_run_01.sh -f $file_path -c $cores

echo "cutadapt script completed!"

