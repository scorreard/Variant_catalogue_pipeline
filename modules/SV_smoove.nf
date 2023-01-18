// Nextflow process
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// SV calling. Call variants using smoove
// compress, change the header and index the compressed file


process SV_smoove {
	tag "${bam.simpleName}"
	label 'process_medium'

	container = "https://depot.galaxyproject.org/singularity/smoove:0.2.8--h9ee0642_1" 

	publishDir "$params.outdir_ind/${assembly}/${batch}/${run}/SV/Sample/smoove", mode: 'copyNoFollow'
	
	input:
	file bam
	file bai
	file reference
	file reference_index
	val assembly
	val batch
	val run

	output:
	file("${bam.simpleName}.vcf.gz")	
	
	script:
	"""
	if [ -a $params.outdir_ind/${assembly}/*/${run}/SV/Sample/smoove/${bam.simpleName}_smoove.vcf.gz ]; then
		smoove_vcf=\$(find $params.outdir_ind/${assembly}/*/${run}/SV/Sample/smoove/ -name ${bam.simpleName}_smoove.vcf.gz)
		smoove_index=\$(find $params.outdir_ind/${assembly}/*/${run}/SV/Sample/smoove/ -name ${bam.simpleName}_smoove.vcf.gz.tbi)
                ln -s \$smoove_vcf .
                ln -s \$smoove_index .
	else
		smoove call \
		--outdir . \
		--name ${bam.simpleName} \
		--fasta ${reference}\
		${bam}
  		##-p ${task.cpus} 
	
	mv ${bam.simpleName}-smoove.vcf.gz ${bam.simpleName}.vcf.gz
	
	fi
	"""
}
