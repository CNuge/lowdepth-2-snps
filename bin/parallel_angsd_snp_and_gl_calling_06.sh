#!/bin/bash

while getopts f:b:s:c:o:p: flag
do
    case "${flag}" in
        f) file_path=${OPTARG};;
        b) bam_filelist=${OPTARG};;
        s) scaffolds=${OPTARG};;
		c) cores=${OPTARG};;
		o) out_path=${OPTARG};;
		p) prefix=${OPTARG};; 
    esac
done

echo "path to the .bam files to be processed: $file_path";
echo "path to the file listing the bam file names: $bam_filelist";
echo "path to the file listing the names of scaffolds/chromsomes to be processed: $scaffold";
echo "number of cores being used in parallel function call: $cores";
echo "the place where output files are being saved to: $out_path"
echo "The species/experiment specifix prefic being applied to per-scaffold output files: $prefix";

total=$(cat $bam_filelist | wc -l )
frac=.8
flt_num=$(echo "scale=4; $total*$frac" | bc )
total_80=${flt_num%.*}
echo "80% of sequenced individuals is equal to : $total_80"
echo "-minInd set to 80% of sequenced individuals count (# lines in .bam file)"
echo "-setMinDepth set to 80% of sequenced individuals count"

echo "entering output directory"
cd $out_path

#while read chr; do
#	echo "on chromosome:"
#	echo $chr

#	echo "running angsd call"
#	angsd -nThreads $cores \
#		-doGlf 2 \
#		-dobcf 1 \
#		-dopost 1 \
#		-gl 1 \
#		-domajorminor 1 \
#		-domaf 1 \
#		--ignore-RG 0 \
#		-dogeno 1 \
#		-docounts 1 \
#		-minMapQ 30 \
#		-minQ 20 \
#		-minInd $total_80 \
#		-out $prefix$chr \
#		-SNP_pval 2e-6 \
#		-minMaf 0.01 \
#		-dumpCounts 2 \
#		-doQsDist 1 \
#		-setMinDepth $total_80 \
#		-uniqueOnly 1 \
#		-remove_bads 1 \
#		-r $chr: \
#		-only_proper_pairs 1 \
#		-bam $bam_filelist #& #the ampersand starts them in parallel, FAILS!
#done <$scaffolds

# maybe one at a time is fine, using the multithread so how much better can it be?
# double multithread seems to be running, so will leave this for now, and see if it completes
cat $scaffolds | \
	parallel -j $cores \
		angsd -nThreads $cores \
			-doGlf 2 \
			-dobcf 1 \
			-dopost 1 \
			-gl 1 \
			-domajorminor 1 \
			-domaf 1 \
			--ignore-RG 0 \
			-dogeno 1 \
			-docounts 1 \
			-minMapQ 30 \
			-minQ 20 \
			-minInd $total_80 \
			-out $prefix{} \
			-SNP_pval 2e-6 \
			-minMaf 0.01 \
			-dumpCounts 2 \
			-doQsDist 1 \
			-setMinDepth $total_80 \
			-uniqueOnly 1 \
			-remove_bads 1 \
			-r {}: \
			-only_proper_pairs 1 \
			-bam $bam_filelist #& #the ampersand starts them in parallel, FAILS!




#testing:
#scaffolds="cunner_chr_names.txt"
#echo $scaffolds

#what do all these options do?
# take a look at the manual, its a little spotty though!
# here are the higlights for the call above

#-nThreads 32 #threadcount
#-doGlf # in the docs for GL, so it is a subargument?
#-dobcf #Wrapper around -dopost -domajorminor -dofreq -gl -dovcf docounts   
#-doPost # (Calculate posterior prob 3xgprob)  
#-GL             #Estimate genotype likelihoods (same as -doGlf?)
#-doMajorMinor   #Infer the major/minor using different approaches 
#-doMaf          #Estimate allele frequencies        
#-doCounts       #(Count the number A,C,G,T. All sites, All samples) 

#-minMapQ #Map base quality? not in the docs
#-minQ   #(minimum base quality; only used in pileupreader) 

#-minInd #(Discard site if effective sample size below value.
#-out #not in docstrings, looks like you give a prefix andd it'll dump a pile of things with diffenrent extensions?

#-r #the chromsome name, a trailing : says you want all of the chr
#	# ie. -r ssa29: means all of chr 29 in AS
