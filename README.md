# lowdepth-2-snps
A bioinformatics pipeline to process low depth re-sequencing data and produce SNP calls and genotype likelihoods

## setup and use

	1. clone repository

	2. place data paired read data into the /data/ folder 
		- your genome (.fna suffix) and paired fq files
		- alternatively change the path in the /scripts/ files to interact with data in another location

	3. open the checklist file
		- alter slurm scripts as needed (increase time or cores if bigger datasets)
		- make the job scheduler class

	4. start the slurm job submission checklist



## TODO
[] bin scripts add
[] slurm calls add
[] change path imports on slurm scripts
	- try to make things relative, so that the amount of hard coding is minimized
[] work on checklist
	- add info on what can be changed, 
	- add some detail to what each step is doing.
[] change scripts to save files to logs
[] document "things you need to provide"
	- genome file
	- fq files
	- a list of chr names
	- see if others
[]
[]
