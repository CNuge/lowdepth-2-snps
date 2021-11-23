
############################
# Slurm submission checklist
############################


#[] 0. preprocessing and data acquisitions

echo "Housekeeping step!" 
echo "Before you begin, get all the .fq files you want to work with in one directory."
echo "Make sure fq data are paired, that you have a reference genome copy,"
echo "and that any bad samples are removed before you begin."
echo "This will involve a human in the loop."


#[] 1. clean fq files
## Arguments to alter in this script:
##      - file_path : location where the input data is found
##      - cores     : number of cpus for parallelization
## input: paired fastq files with suffix R1.fastq.gz and R2.fastq.gz
## output: fastq files with the suffix _trim.fastq.gz
## software used : cutadapt
echo "clean the data using cutadapt"
echo "note: in the future this step may change due to use of alternative trim software"
sbatch 01_run_cutadapt.sh


#[] 2. alignment to genome 
## Arguments to alter in this script:
##      - file_path   : location where the input data is found
##      - genome_file : path to the reference genome .fasta to align data to
##      - outfolder   : location where the outputs should be saved to
##      - cores     : number of cpus for parallelization
fastq files with the suffix _trim.fastq.gz
## input  : fastq files with the suffix _trim.fastq.gz
## output : raw .bam files, sorted .bam files with suffix .sorted.bam
## software used : bwa, samtools
echo "bwa alignment of trimmed fq data to the genome"
sbatch 02_align_to_genome.sh


#[] 3. deduplicate bam files
## Arguments to alter in this script:
##         - file_path   : location where the input data is found
## input  : .sorted.bam files from step 2
## output : deduplicated .bam file with suffix deDup.bam and accompanying 
##          metrics file with suffix deDupMetrics.txt.
##          Output to same folder as input.
## software used : picard 
echo "bam file cleanup, deduplicate reads"
sbatch 03_deduplicate_and_cleanup.sh


#[] 4. housekeeping
## Arguments to alter in this script:
##      - file_path       : location where the input data is found
##      - genome_file     : path to the reference genome .fasta to align data to
##      - read_group_name : read group identifier added to header
##      - cores           : number of cpus for parallelization
## input  : A reference genome and deduplicated .bam file with suffix .deDup.bam (from step 3)
## output : A reference sequence dictionary (in same folder as reference genome)
##          bam index .bai files (in same folder as input .deDup.bam files)
##            bam files with suffix RG.deDup.bam (read_group added to header)
## software used : picard, samtools
echo "bam file cleanup, alter the header information and index files. make genome dictonary"
sbatch 04_genome_dict_and_header_fix.sh


#[] 5. indel realignment
## Arguments to alter in this script:
##      - file_path       : location where the input data is found
##      - genome_file     : path to the reference genome .fasta (with accompanying dictionary) to align data to
##      - cores           : number of cpus for parallelization
## input  : bam files with suffix RG.deDup.bam and indexed genome file
## output : bam files with the suffix .realigned.bam (include realigned sequences)
##          .intervals files (intermediate file used in realignment)
## software used : gatk version 3.8 (note version 4 had no realignment option)
echo "conduct the indel realignment"
echo "with move to gatk4.0 this step may become obsolete"
sbatch 05_indel_realignment.sh


#[] 6. SNP and genotype likelihood calling (chromosome-by-chromosome)
## Arguments to alter in this script:
##      - file_path        : location where the input data is found
##      - bam_names_file   : A list of .bam files to be considered
##                           Optionally produced for you from contents of file_path
##      - chr_names_file   : A list of chromosome names to call snps for (select these from you genome_file)
##      - output_prefix    : prefix to add to the outputs (format will be: "<output_prefix><chromosome>")
##      - cores            : number of cpus for parallelization
## input  : see arguments
## output : .beagle.gz and .bcf for each chromosome (format will be: "<output_prefix><chromosome>.beagle.gz")
## software used : angsd
echo "ANGSD to get the SNP calls and genotype likelihoods"
echo "these files are generated on a per chromosome basis"
sbatch 07_run_pcangsd.sh


#[] 7. Convert the by-chromosome .bcf files to non-binary vcf format
## Arguments to alter in this script:
##       - file_path        : location where the input data is found
## input  : .bcf files
## output : .vcf files
## software used : bcftools
sbatch 07_bcf_to_vcf.sh