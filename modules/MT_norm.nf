// Nextflow process
// Created by Solenne Correard in December 2021
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// Step merging the 2 vcf files (including the MT variants called against the reference genome and the shifted reference genome) for each individual
// bcftools norm remove the variants that are duplicated within the merge files (variants that were called against both references)

process MT_norm {
        tag "${MT_MergeVcfs.simpleName}"
	label 'process_medium'

    conda "bioconda::bcftools=1.16"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/bcftools:1.16--hfe4b78e_1':
        'quay.io/biocontainers/bcftools:1.16--hfe4b78e_1' }"
	
        input :
	file MT_MergeVcfs
	val assembly
	val batch
	val run

        output :
	path '*_merged.vcf.gz', emit : vcf
	path '*_merged.vcf.gz.tbi', emit : index

        script :
        """
        echo ${MT_MergeVcfs.simpleName}
	sample_name=\$(echo ${MT_MergeVcfs.simpleName} | cut -d _ -f 1)
	echo \$sample_name

	if [ -a $params.outdir_ind/${assembly}/*/${run}/MT/Sample/\${sample_name}_MT_merged_filtered_trimmed_filtered_sites.vcf.gz ]; then
		touch \${sample_name}_MT_merged.vcf.gz
		touch \${sample_name}_MT_merged.vcf.gz.tbi
	else
		bcftools norm --rm-dup both \${sample_name}_MT_merged_uncollapsed.vcf.gz -O z -o \${sample_name}_MT_merged.vcf.gz 
		bcftools index -t \${sample_name}_MT_merged.vcf.gz 
	fi
	"""
}
