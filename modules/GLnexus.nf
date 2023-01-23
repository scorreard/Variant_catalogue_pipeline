// Nextflow process
// Created by Solenne Correard in December 2021
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// SNV Caling. GLnexus to do joint variant calling
// GLnexus also include a varaint filtering step, that according to publications, is as good as GATK VQSR, so no additional step is needed.

process GLnexus_cli {
	label 'process_high'

    conda "bioconda::glnexus=1.4.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/glnexus:1.4.1--h40d77a6_0' :
        'quay.io/biocontainers/glnexus:1.4.1--h40d77a6_0' }"
	
	input :
	file list_gvcf
	val run
        
	output :
	path '*.bcf'

	script :
	"""
	glnexus_cli \
	--config DeepVariantWGS \
	--mem-gbytes 128 \
	--list ${list_gvcf} > DeepVariant_GLnexus_${run}.bcf
	"""
}

