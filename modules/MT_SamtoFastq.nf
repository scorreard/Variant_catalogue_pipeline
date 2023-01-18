// Nextflow process
// Created by Solenne Correard in December 2021
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// MT. Convert the bam file containing only the reads mapping against the MT chromosome into fastq

process MT_SamtoFastq {
        tag "${Extract_MT_Read.baseName}"
	label 'process_low'

	container = "https://depot.galaxyproject.org/singularity/gatk4%3A4.3.0.0--py36hdfd78af_0"
	
        input :
        file Extract_MT_Read
        val assembly
        val batch
        val run

        output :
        path '*.fastq', emit : fastq_MT

        script :
        """
	sample_name=\$(echo ${Extract_MT_Read.baseName} | cut -d _ -f 1)
	if [ -a $params.outdir_ind/${assembly}/*/${run}/MT/Sample/\${sample_name}_MT_merged_filtered_trimmed_filtered_sites.vcf.gz ]; then
		touch \${sample_name}.fastq
	else
        	gatk SamToFastq \
        	INPUT=${Extract_MT_Read.baseName}.bam \
        	FASTQ=${Extract_MT_Read.baseName}.fastq \
        	INTERLEAVE=true \
        	NON_PF=true
	fi
	"""
}

