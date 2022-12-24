// Nextflow process
// Owned by the Silent Genomes Project Activity 3 team
// Developped to build the IBVL, a background variant library

// Overview of the process goal and characteristics :
// SV calling. Genotype the Short Tendem Repeat (STR) using Expension Hunter
// Rename the STR, compress the vcf and index the compressed vcf

// Future possible improvement : Use ExpensionHunterDeNovo


process expansion_hunter_bcftools {
	tag "${EH_vcf.simpleName}"

        publishDir "$params.outdir_ind/${assembly}/${batch}/${run}/STR/Sample/", mode: 'copyNoFollow'

	input:
	file EH_vcf
  val assembly
  val batch
  val run

	output:
	path '*_str.vcf.gz', emit : vcf
  path '*_str.vcf.gz.tbi', emit : vcf_index

	script:
	"""
	if [ -a $params.outdir_ind/${assembly}/*/${run}/STR/Sample/${EH_vcf.simpleName}_str.vcf.gz ]; then
		exp_hunt_vcf=\$(find $params.outdir_ind/${assembly}/*/${run}/STR/Sample/ -name ${EH_vcf.simpleName}_str.vcf.gz)
		exp_hunt_index=\$(find $params.outdir_ind/${assembly}/*/${run}/STR/Sample/ -name ${EH_vcf.simpleName}_str.vcf.gz.tbi)
		ln -s \$exp_hunt_vcf .
		ln -s \$exp_hunt_index .
	else	
		bcftools view -O z -o ${EH_vcf.simpleName}_str_noID.vcf.gz ${EH_vcf}
		bcftools index ${EH_vcf.simpleName}_str_noID.vcf.gz
		bcftools annotate --set-id '%CHROM\\_%POS\\_%END\\_%REF\\_%ALT' -O z -o ${EH_vcf.simpleName}_str.vcf.gz ${EH_vcf.simpleName}_str_noID.vcf.gz
		bcftools index --tbi ${EH_vcf.simpleName}_str.vcf.gz
	fi
	"""
}
