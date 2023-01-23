// Quality check of the bam file with Picard QualityScoreDistribution
// This tool is used for determining the overall 'quality' for a library in a given run. To that effect, it outputs a chart and tables indicating the range of quality scores and the total numbers of bases corresponding to those scores. 
// (!) R is necessary for the chart


process Picard_QualityScoreDistribution {
        tag "${bam.simpleName}"
	label 'process_low'

    conda "bioconda::picard=2.27.4 r::r-base"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/picard:2.27.4--hdfd78af_0' :
        'quay.io/biocontainers/picard:2.27.4--hdfd78af_0' }"

	publishDir "$params.outdir_ind/${assembly}/${batch}/${run}/QC/Individuals/${bam.simpleName}/Picard_Metrics/", mode: 'copyNoFollow'
	
	input :
	file bam
	file bai
	val assembly
	val batch
	val run

	output :
	file '*_qual_score_dist.*' 

	script :
	"""
	if [ -a $params.outdir_ind/${assembly}/*/${run}/QC/Individuals/${bam.simpleName}/Picard_Metrics/${bam.simpleName}_qual_score_dist.txt ]; then
		picard_qual_score_txt=\$(find $params.outdir_ind/${assembly}/*/${run}/QC/Individuals/${bam.simpleName}/Picard_Metrics/ -name ${bam.simpleName}_qual_score_dist.txt)
		picard_qual_score_pdf=\$(find $params.outdir_ind/${assembly}/*/${run}/QC/Individuals/${bam.simpleName}/Picard_Metrics/ -name ${bam.simpleName}_qual_score_dist.pdf)
		ln -s \$picard_qual_score_txt .
                ln -s \$picard_qual_score_pdf .
	else
		picard "-Xmx2G" QualityScoreDistribution \
		I=${bam} \
		O=${bam.simpleName}_qual_score_dist.txt \
		CHART= ${bam.simpleName}_qual_score_dist.pdf
	fi
	"""
}

