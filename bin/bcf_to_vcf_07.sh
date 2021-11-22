while getopts f: flag
do
    case "${flag}" in
        f) file_path=${OPTARG};;
    esac
done


echo "path to the .bcf files to be processed: $file_path";

cd $file_path

bcf_files=$(ls *.bcf | sed 's/.bcf//');


for f in $bcf_files;
do
	infile=$f".bcf"
	outfile=$f".vcf"
	echo "on file"
	echo $infile
	bcftools view $infile > $outfile

done


