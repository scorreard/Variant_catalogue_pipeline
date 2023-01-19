// Nextflow process
// Created by Solenne Correard in December 2021
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics:
// Alignment. fastq alignment with bwa mem 
//	      Sort and index with samtools

// Process should be skipped if bam file already generated

process align_sort_output_bam {
	tag "$sampleId"
	label 'process_medium'

        container = 'https://depot.galaxyproject.org/singularity/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:219b6c272b25e7e642ae3ff0bf0c5c81a5135ab4-0'

	publishDir "$params.outdir_ind/${assembly}/${batch}/${run}/BAM/", mode: 'copyNoFollow'

	input :
	path reference
	path reference_index
	tuple val(sampleId), path ('read_pairs_ch')
	val assembly
	val batch
	val run

	output :
	path '*.bam', emit: samples_bam
	path '*.bam.bai', emit: samples_bam_index

	script:
	def args = task.ext.args ?: ''
	"""
	if [ -a ${params.outdir_ind}/${assembly}/*/${run}/BAM/${sampleId}_sorted.bam ]; then
		bam_file=\$(find ${params.outdir_ind}/${assembly}/*/${run}/BAM/ -name ${sampleId}_sorted.bam)
                bai_file=\$(find ${params.outdir_ind}/${assembly}/*/${run}/BAM/ -name ${sampleId}_sorted.bam.bai)
		ln -s \$bam_file .
		ln -s \$bai_file .
	else
		bwa mem -t 8 $args ${reference} ${read_pairs_ch} | samtools view -Sb | samtools sort -o ${sampleId}_sorted.bam
		samtools index ${sampleId}_sorted.bam
	fi
	"""
}

