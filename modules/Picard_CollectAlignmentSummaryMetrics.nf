// Nextflow process
// Created by Solenne Correard in December 2021
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// Quality check of the bam file with Picard CollectAlignmentSummaryMetrics
// This tool takes a SAM/BAM file input and produces metrics detailing the quality of the read alignments as well as the proportion of the reads that passed machine signal-to-noise threshold quality filters. 


process Picard_CollectAlignmentSummaryMetrics {
        tag "${bam}"
	label 'process_medium'

    conda "bioconda::gatk4=4.3.0.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/gatk4:4.3.0.0--py36hdfd78af_0':
        'quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0' }"
	
	publishDir "$params.outdir_ind/${assembly}/${batch}/${run}/QC/Individuals/${bam.simpleName}/Picard_Metrics/", mode: 'copyNoFollow'

	input :
	file bam
	file bai 
	val assembly
	val batch
	val run
	
	output :
	file '*_Picard_Alignment*'

	script :
	"""
	if [ -a $params.outdir_ind/${assembly}/*/${run}/QC/Individuals/${bam.simpleName}/Picard_Metrics/${bam.simpleName}_Picard_Alignment ]; then
		Picard_Alignment=\$(find $params.outdir_ind/${assembly}/*/${run}/QC/Individuals/${bam.simpleName}/Picard_Metrics/ -name ${bam.simpleName}_Picard_Alignment)
		ln -s \$Picard_Alignment
	else
        	gatk CollectAlignmentSummaryMetrics \
		--java-options "-Xmx2000M" \
		-I ${bam} \
		-O ${bam.simpleName}_Picard_Alignment
	fi
	"""
}

