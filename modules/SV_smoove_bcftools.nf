// Nextflow process
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// SV calling. Call variants using smoove
// compress, change the header and index the compressed file


process SV_smoove_bcftools {
	tag "${smoove_vcf.simpleName}"
	label 'process_medium'

    conda "bioconda::bcftools=1.16"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/bcftools:1.16--hfe4b78e_1':
        'quay.io/biocontainers/bcftools:1.16--hfe4b78e_1' }"
	
	publishDir "$params.outdir_ind/${assembly}/${batch}/${run}/SV/Sample/smoove", mode: 'copyNoFollow'
	
	input:
	file smoove_vcf
	val assembly
	val batch
	val run

	output:
	tuple(file("${smoove_vcf.simpleName}_smoove.vcf.gz"),file("${smoove_vcf.simpleName}_smoove.vcf.gz.tbi"),val(smoove_vcf.simpleName))	
	
	script:
	"""
	if [ -a $params.outdir_ind/${assembly}/*/${run}/SV/Sample/smoove/${smoove_vcf.simpleName}_smoove.vcf.gz ]; then
		smoove_vcf=\$(find $params.outdir_ind/${assembly}/*/${run}/SV/Sample/smoove/ -name ${smoove_vcf.simpleName}_smoove.vcf.gz)
		smoove_index=\$(find $params.outdir_ind/${assembly}/*/${run}/SV/Sample/smoove/ -name ${smoove_vcf.simpleName}_smoove.vcf.gz.tbi)
                ln -s \$smoove_vcf .
                ln -s \$smoove_index .
	else
		echo ${smoove_vcf.simpleName}
		sample_name=\$(echo ${smoove_vcf.simpleName} | cut -d _ -f 1)
		echo \$sample_name > sample.txt

		bcftools view -O u -o ${smoove_vcf.simpleName}.R.bcf ${smoove_vcf}
		bcftools sort --temp-dir $params.outdir_ind/${assembly}/${batch}/${run}/SV/TMP  -m 2G -O z -o ${smoove_vcf.simpleName}-smoove.vcf.gz  ${smoove_vcf.simpleName}.R.bcf
		bcftools reheader -s sample.txt ${smoove_vcf.simpleName}-smoove.vcf.gz > ${smoove_vcf.simpleName}_smoove.vcf.gz
		bcftools index --tbi ${smoove_vcf.simpleName}_smoove.vcf.gz
	fi
	"""
}
