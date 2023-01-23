// Nextflow process
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics:
// Fix the bam files adding tags to allow faster processing by some future steps


process samtools_fixmate {
	label 'process_medium'
	tag "${bam.SimpleName}"
	
  conda "bioconda::samtools=1.16.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/samtools:1.16.1--h6899075_1' :
        'quay.io/biocontainers/samtools:1.16.1--h6899075_1' }"
	
	input :
	file bam
	file bai
	val assembly
	val batch
	val run

	output :
	path '*_fixmate_ordered.bam', emit: samples_fixmate_bam
	path '*_fixmate_ordered.bam.bai', emit: samples_fixmate_bam_index

	script:
	"""
	sample_name=\$(echo ${bam.simpleName} | cut -d _ -f 1)
	if [ -a $params.outdir_ind/${assembly}/*/${run}/MEI/Sample/\${sample_name}_mei.vcf.gz ]; then
		touch \${sample_name}_fixmate_ordered.bam
		touch \${sample_name}_fixmate_ordered.bam.bai
	else
		# Resort the bam file by query name for samtools fixmate (coordiante-sorted bam does not work)
		samtools sort -n -O BAM -@ 20  ${bam} > ${bam.SimpleName}_nsorted.bam

		# Samtools fixmate will add MQ tags
		samtools fixmate -m -O BAM -@ 20  ${bam.SimpleName}_nsorted.bam  ${bam.SimpleName}_fixmate.bam

		# Now sort bam file by coordinates to resume the pipeline 
		samtools sort  -@ 20  ${bam.SimpleName}_fixmate.bam -o ${bam.SimpleName}_fixmate_ordered.bam

		# index the sorted bam file
		samtools index  -@ 20  ${bam.SimpleName}_fixmate_ordered.bam
	fi
	"""
}

