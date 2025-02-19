process MT_Step3_metadata_sample {
	label 'process_medium'
	
        container = 'https://depot.galaxyproject.org/singularity/r-stringr%3A1.1.0--r3.3.1_0'

	input :
	path mosdepth
	path haplocheck
	val assembly
	val batch
	val run
	
	output :
	path '*', emit : MT_Step3_metadata_sample

	script:
	"""
        sample_name=\$(echo ${haplocheck.simpleName} | sed 's/_.*//' )
	if [ -a $params.outdir_ind/${assembly}/*/${run}/MT/Sample/\${sample_name}_MT_merged_filtered_trimmed_filtered_sites.vcf.gz ]; then
		touch \${sample_name}_conta_cov.tsv
	else
		Rscript ${projectDir}/modules/MT_Step3_metadata_sample.R \${sample_name}_sorted.mosdepth.summary.txt ${haplocheck} 
		mv conta_cov.tsv \${sample_name}_conta_cov.tsv
	fi
	"""
}
