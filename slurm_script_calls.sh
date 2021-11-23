
############################
# Slurm submission checklist
############################


#[] 0. preprocessing and data acquisitions
## To alter in this slurm script:
## 		-
echo "housekeeping step, get all the files you want to work with in one directory"
echo "this will involve a human in the loop"
sbatch scripts/00_bad_sample_rm.sh


#[] 1. clean fq files
## To alter in this slurm script:
## 		-
echo "clean the data using cutadapt"
echo "note this step may change due to use of alternative trim software"
sbatch scripts/01_run_cutadapt.sh


#[] 2. alignment to genome 
## To alter in this slurm script:
## 		-
echo "bwa alignment of trimmed fq data to the genome"
sbatch scripts/02_align_to_genome.sh


#[] 3. deduplicate bam files
## To alter in this slurm script:
## 		-
echo "bam file cleanup, deduplicate reads"
sbatch scripts/03_deduplicate_and_cleanup.sh


#[] 4. housekeeping
## To alter in this slurm script:
## 		-
echo "bam file cleanup, alter the header information and index files. make genome dictonary"
sbatch scripts/04_genome_dict_and_header_fix.sh


#[] 5. indel realignment
## To alter in this slurm script:
## 		-
echo "conduct the indel realignment"
echo "with move to gatk4.0 this step may become obsolete"
sbatch scripts/05_indel_realignment.sh


#[] 6 SNP and genotype likelihood calling
## To alter in this slurm script:
## 		-
echo "ANGSD to get the SNP calls and genotype likelihoods"
echo "these are generated on a per snp basis"
sbatch scripts/07_run_pcangsd.sh


#[] 7. convert the by-chromosome .bcf files to non-binary vcf format
sbatch 07_bcf_to_vcf.sh