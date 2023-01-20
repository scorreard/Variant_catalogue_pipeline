// Nextflow process
// Created by Solenne Correard in December 2021
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// Run a R script that organize the SNV variants information in the tables expected to be displayed in the IBVL interface

process STR_data_organization {
	label 'process_low'

        container = 'https://depot.galaxyproject.org/singularity/r-vcfr%3A1.8.0--r36h0357c0b_3'

        publishDir "$params.outdir_pop/${assembly}/${run}/Oracle_table/str/", mode: 'copy', pattern: "str.tsv"
	publishDir "$params.outdir_pop/${assembly}/${run}/Oracle_table/variants/", mode: 'copy', pattern: "variants_str.tsv"
        publishDir "$params.outdir_pop/${assembly}/${run}/Oracle_table/genes/", mode: 'copy', pattern: "genes_str.tsv"
        publishDir "$params.outdir_pop/${assembly}/${run}/Oracle_table/sv_consequences/", mode: 'copy', pattern: "sv_consequences_str.tsv"


	input :
	path STR_vcf
	path STR_catalogue
	val assembly
	val run
	val var_type 

	output :
	path '*'

	script:
	"""
	Rscript ${projectDir}/modules/STR_data_organization.R $assembly ${STR_vcf} ${STR_catalogue}  $run ${var_type}
	"""
}
