# Important disclaimer about this repo

This repo is a clone from https://github.com/wassermanlab/Variant_catalogue_pipeline and a Work In Progress.

https://github.com/wassermanlab/Variant_catalogue_pipeline **must** be considered as the main repo and be the one cited or mentionned if you use this code.

The purpose of this repo is to migrate the variant catalogue pipeline to nf-core standard.



It is possible to use this repo to test the pipeline on public, "reduced", dummy data.

The test data contains fastq files from 5 individuals (regions of chr20, chrX, chrY, chrM), the reference genome (GRCh38) for chr20, chrX, chrY and chrM. Moreover, it contains a subset of the files necessary to run some of the tools.

To test the pipeline on you server, you need nextflow, singularity and conda installed, then use :

```
git clone https://github.com/scorreard/Variant_catalogue_pipeline.git
gzip -d Variant_catalogue_pipeline/testdata/reference/hg38_full_analysis_set_plus_decoy_hla_chr20_X_Y_MT.fa.gz 
nextflow run scorreard/Variant_catalogue_pipeline -resume -latest -r main -profile GRCh38
```

Because the fasta reference files where too big to be uploaded as one file, I broke them down, hence the step to merge them before running the pipeline

The test is complete for the SNV and MT

The test is incomplete for the SV part as expansionHunter V5 (for STR calling) and MELT (for MEI calling) don't have containers.

The test can only be done with GRCh38

If the test fails, please, create an issue. Thanks.




# Variant catalogue Pipeline


## Introduction

**The variant catalogue Pipeline** is a workflow designed to generate variant catalogues, a list of variants and their frequencies in a population, from whole genome sequences.

the variant catalogue pipeline is built using [Nextflow](https://www.nextflow.io), a workflow tool to run tasks across multiple compute infrastructures in a very portable manner. It takes as input Whole Genome Sequence (WGS) data and outputs multiple vcf files including the variant allele frequencies in the cohort and some basic annotation.

The variant catalogue pipeline includes detection of Single Nucleotide Variants (SNV), small insertions and deletions (indels), Mitochondrial variants, Structural Variants (SV), Mobile Element Insertions (MEI), and Short Tandem Repeats (STR). The output variant catalogue can be generated for GRCh37 and/or GRCh38 human reference genomes.

<p align="center">
    <img title="The variant catalogue Workflow" src="https://user-images.githubusercontent.com/54953390/190030122-22e38401-4131-46b9-9af5-dbbe45f50650.png" width=50%>
</p>
<p align="center">
Figure : Overview of the variant catalogue pipeline
</p>


## Pipeline description

The variant catalogue is composed of four sub-workflows represented by the grey boxes in the figure. The structure allows users to run the pipeline as a whole or choose to run individual sub-workflow(s) of interest. Each sub-workflow is composed of modules, which call upon open-access genomic software.

A more detailed description of the pipeline will be available soon.

Detailed representation of the variant catalogue pipeline : [CAFE_supp.pdf](https://github.com/scorreard/CAFE_Readme/files/9480518/CAFE_supp.pdf)

## Pipeline availability

The variant catalogue pipeline is implemented in the NextFlow framework and relies only on open-access tools, therefore, any user with sufficient compute capacity should be able to use this pipeline. Users who want to use this pipeline on their local servers will have to install the necessary software on their instance.

All the software required to run the variant catalogue pipeline are open-source and the link to the installation guidelines are available in [supplementary_information/software_information.md](https://github.com/wassermanlab/CAFE_pipeline/blob/main/supplementary_information/software_information.md).

All the other resources necessary to run the pipeline (Reference genomes, annotation plugins, etc) are also publicly available and information related to them are available for [GRCh37](https://github.com/wassermanlab/CAFE_pipeline/blob/main/supplementary_information/GRCh37_specific_files.md) in supplementary_information/GRCh37_specific_files.md, for [GRCh38](https://github.com/wassermanlab/CAFE_pipeline/blob/main/supplementary_information/GRCh38_specific_files.md) in supplementary_information/GRCh38_specific_files.md and for [the mitochondrial genome](https://github.com/wassermanlab/CAFE_pipeline/blob/main/supplementary_information/Mitochondrial_references.md) in supplementary_information/Mitochondrial_references.md.

## Future of the pipeline

There is discussions with the [NF_core](https://nf-co.re) team to move the variant catalogue pipeline to NF-core and improve and maintain this pipeline with the help of the community. Feel free to join in the effort!


## Pipeline test on 100 genomes

In order to test the variant catalogue pipeline, 100 samples from the IGSR (International Genome Sample Resource) were processed. A more precise description of the method and results will be available soon. 

The samples were processed in two batches, [batch_1](https://github.com/wassermanlab/CAFE_pipeline/blob/main/test_case/80_samples_information) contained 80 samples and [batch_2](https://github.com/wassermanlab/CAFE_pipeline/blob/main/test_case/20_samples_information) contained 20 samples.
Output files generated by Nextflow (report, timeline, etc) are available in the test_case folder and vcf files containing annotated variant frequencies are also available in that folder. Intermediate files were not loaded into GitHub.






