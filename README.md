# lowdepth-2-snps
A bioinformatics pipeline to process low depth re-sequencing data and produce SNP calls and genotype likelihoods.

## Introduction

This pipeline is meant to facilitate the processing of paired-end illumina low depth sequencing data for a series of individuals, taking the data from raw fq files all the way to a final set of genotype likelihood files (.beagle) and variant calls (.vcf files).


### Here is a brief summary of the pipeline's steps that accomplish this task:

1. trim the fq files with cutadapt (makes trimmed .fq files)

2. align the sequences to a reference genome (make .bam files for each individual)

3. deduplicate and clean up the alginment data (makes .bam files for each individual)

4. add information about individuals into the header  (makes .bam files for each individual)

5. realign seqences in the .bam files to improve the SNP calling (makes .bam files for each individual)

6. call SNPs from the curated alignment data files, gets genotypes and genotype likelihoods (makes a .beagle file and a .bcf file for each chromosome in the genome)

7. convert the .bcf outputs to .vcf format.


### What you need
- Paired end sequence files (.fq.gz format, a pair of fq files for each individual)
- A reference genome in .fasta format (you'll have to specify this file's location)
- A compute canada account, or other environment that uses a slurm scheduler
- A text file with the list of the chromosome names you want to call SNPs for
	- can build this as follows:
	```
	cat your_genome_file.fasta | grep ">" >> chr_names.txt
	#then open the file produced and delete lines with chromosomes or scaffolds you don't want SNPs called for.
	```

## Setup and Use

1. Clone this repository.

2. Place data paired read data into the `data/` folder 
	- your genome (.fna suffix) and paired fq files
	- alternatively change the path in the /scripts/ files to interact with data in another location
	- there is a `.gitignore` file in the `data/` folder so data added is by default ignored by git.

3. Open the checklist file (`slurm_script_calls.sh`)
	- alter the numbered slurm scripts in the top directory as needed (specify you data location, increase time or cores if bigger datasets)
	- make the job scheduler calls by pasting the sbatch commands into the terminal (on compute canada server)
	- as your jobs finish, check the log files to make sure there are no problems, then move on to the next step.


