// Nextflow process
// Created by Solenne Correard in December 2021
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// Index the reference genomes
// Used multiple times (reference genome and MT specific reference genomes (non shifted and shifted))

process bwa_index {
        tag "$genome"
	label 'process_medium'
	
	container = "https://depot.galaxyproject.org/singularity/bwa:0.7.17--hed695b0_7"
	
	input:
        path genome

        output :
        file '*'

        script:
        """
        bwa index ${genome}
        """
}
