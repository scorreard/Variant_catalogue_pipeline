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
	"""
	if [ -a ${params.outdir_ind}/${assembly}/*/${run}/BAM/${sampleId}_sorted.bam ]; then
		bam_file=\$(find ${params.outdir_ind}/${assembly}/*/${run}/BAM/ -name ${sampleId}_sorted.bam)
                bai_file=\$(find ${params.outdir_ind}/${assembly}/*/${run}/BAM/ -name ${sampleId}_sorted.bam.bai)
		ln -s \$bam_file .
		ln -s \$bai_file .
	else
		bwa mem -t 8 -R '@RG\\tID:${sampleId}\\tSM:${sampleId}' ${reference} ${read_pairs_ch} | samtools view -Sb | samtools sort -o ${sampleId}_sorted.bam
		samtools index ${sampleId}_sorted.bam
	fi
	"""
}

