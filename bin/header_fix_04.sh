
#!/bin/bash

while getopts g:f:c:r: flag
do
    case "${flag}" in
        g) genome_file=${OPTARG};;
        f) file_path=${OPTARG};;
        c) cores=${OPTARG};;
		r) read_group=${OPTARG};;
    esac
done

echo "path to the paired genome file: $genome_file";
echo "path to the paired .fq files to be processed: $file_path";
echo "number of cores being used in parallel function call: $cores";
echo "read group identifier used: $read_group";


echo "create reference for genome file"
java -Xmx10g -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary -R $genome_file

echo "entering dir"
#go to the file location
cd $file_path


ls *.deDup.bam | sed 's/.deDup.bam//' | \
	parallel -j $cores \
		java -Xmx10g -jar $EBROOTPICARD/picard.jar AddOrReplaceReadGroups \
	  	  VALIDATION_STRINGENCY=LENIENT \
	      I={}.deDup.bam \
	      O={}RG.deDup.bam \
	      RGID={} \
	      RGLB=Generic \
	      RGPL=illumina \
	      RGPU=$read_group \
	      RGSM={}

echo "header fix complete"


echo "indexing the bam files"
ls *RG.deDup.bam | \
	parallel -j $cores \
		samtools index {}

echo "indexing complete"
