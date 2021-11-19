#!/bin/bash

while getopts f:c: flag
do
    case "${flag}" in
        f) file_path=${OPTARG};;
        c) cores=${OPTARG};;

    esac
done

echo "path to the bam files to be processed: $file_path";
echo "number of cores being used: $cores";


#go to the file location
cd $file_path

#this one not working, seems the data aren't getting saved to the designated files
echo "running the deduplication"
ls *.sorted.bam | sed 's/.sorted.bam//' | \
	parallel -j $cores \
		java -Xmx10g -jar $EBROOTPICARD/picard.jar MarkDuplicates \
		  INPUT={}.sorted.bam \
		  OUTPUT={}.deDup.bam \
		  METRICS_FILE={}deDupMetrics.txt \
		  REMOVE_DUPLICATES=true \
		  VALIDATION_STRINGENCY=LENIENT \
		  TMP_DIR=/tmp 



# this is commented out, 
# the  next step is running indexing after resolving the header issue
# indexing twice seems redundant, and next step runs without this.

#echo "indexing the bam files"
#ls *.sorted.bam | sed 's/.sorted.bam//' | \
#	parallel -jobs $cores \
#		samtools index {}.deDup.bam



