// Nextflow process
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// SV calling. Genotype the Short Tendem Repeat (STR) using Expension Hunter
// Rename the STR, compress the vcf and index the compressed vcf

// Future possible improvement : Use ExpensionHunterDeNovo


process expansion_hunter {
	tag "${bam.simpleName}"
	label 'process_medium'

    conda "bioconda::expansionhunter=4.0.2"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/expansionhunter:4.0.2--he785bd8_0' :
        'quay.io/biocontainers/expansionhunter:4.0.2--he785bd8_0' }"
	
        publishDir "$params.outdir_ind/${assembly}/${batch}/${run}/STR/Sample/", mode: 'copyNoFollow'

	input:
	file bam
	file bai
	file reference
	file reference_index
	file variant_catalog
        val assembly
        val batch
        val run

	output:
	path '*vcf', emit : EH_vcf

	script:
	"""
	if [ -a $params.outdir_ind/${assembly}/*/${run}/STR/Sample/${bam.simpleName}_str.vcf.gz ]; then
		exp_hunt_vcf=\$(find $params.outdir_ind/${assembly}/*/${run}/STR/Sample/ -name ${bam.simpleName}_str.vcf.gz)
		exp_hunt_index=\$(find $params.outdir_ind/${assembly}/*/${run}/STR/Sample/ -name ${bam.simpleName}_str.vcf.gz.tbi)
		ln -s \$exp_hunt_vcf .
		ln -s \$exp_hunt_index .
	else
		ExpansionHunter \
		--output-prefix ${bam.simpleName} \
		--reference $reference  \
		--reads ${bam} \
		--variant-catalog ${variant_catalog}
	fi
	"""
}
