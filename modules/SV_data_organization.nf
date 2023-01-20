// Nextflow process
// Created by Solenne Correard in December 2021
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// Run a R script that organize the SNV variants information in the tables expected to be displayed in the IBVL interface

process SV_data_organization {
        tag "${SV_annot_merged}"
	label 'process_medium'

        container = 'https://depot.galaxyproject.org/singularity/r-vcfr%3A1.8.0--r36h0357c0b_3'

	publishDir "$params.outdir_pop/${assembly}/${run}/Oracle_table/genomic_ibvl_frequencies/", mode: 'copy', pattern: "genomic_ibvl_frequencies_SV_*"
	publishDir "$params.outdir_pop/${assembly}/${run}/Oracle_table/svs/", mode: 'copy', pattern: "svs_*"
        publishDir "$params.outdir_pop/${assembly}/${run}/Oracle_table/genes/", mode: 'copy', pattern: "genes_sv_*"
	publishDir "$params.outdir_pop/${assembly}/${run}/Oracle_table/variants/", mode: 'copy', pattern: "variants_sv_SV_[A-Z0-9][A-Z0-9].tsv"
	publishDir "$params.outdir_pop/${assembly}/${run}/Oracle_table/sv_consequences/", mode: 'copy', pattern: "sv_consequences_*"
	publishDir "$params.outdir_pop/${assembly}/${run}/Oracle_table/svs_ctx/", mode: 'copy', pattern: "svs_ctx_*"

	input :
	path SV_annot_merged
	val assembly
	val run
	val var_type 
	path severity_table

	output :
	path '*'

	script:
	"""
	Rscript ${projectDir}/modules/SV_data_organization.R $assembly ${SV_annot_merged} $run ${var_type} $severity_table
	"""
}
