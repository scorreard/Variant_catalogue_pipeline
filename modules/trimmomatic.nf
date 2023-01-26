process TRIMMOMATIC {
	label 'process_medium'

    conda "bioconda::trimmomatic=0.39"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/trimmomatic:0.39--hdfd78af_2':
        'quay.io/biocontainers/trimmomatic:0.39--hdfd78af_2' }"

	
	input:
	tuple (val(sample), file(reads)) 
	path outdir_ind
	val assembly
	val batch
	val run

	output :
	path("*.paired.trim*.fastq.gz"), emit: trimmed_reads

	script :
	"""
	    trimmomatic \\
        PE \\
        -trimlog ${sample}.log \\
        -summary ${sample}.summary \\
        $reads \\
        ${sample}.paired.trim_1.fastq.gz \\
        ${sample}.unpaired.trim_1.fastq.gz \\
        ${sample}.paired.trim_2.fastq.gz \\
        ${sample}.unpaired.trim_2.fastq.gz" \\
        ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True \\
        LEADING:3 \\
        TRAILING:3 \\
        MINLEN:36
	"""
}
