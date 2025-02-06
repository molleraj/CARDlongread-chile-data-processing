#!/bin/bash
# start interactive job with 32GB RAM and 32 CPUs
sinteractive --mem=32g --cpus-per-task=32
# load bcftools and vcftools modules with ml
ml bcftools vcftools
# merge phased, gzipped VCFs
# use list of phased VCFs in Chile_PMDV_phased_vcf_list_080624.txt
bcftools merge --force-samples -l Chile_PMDV_phased_vcf_list_080624.txt -o Chile_PMDV_phased_vcf_merged_080624.vcf
# rename samples based on sample list
bcftools reheader -s <(cut -f1 CHILE_SAMPLE_FLOWCELL.tsv) -o Chile_PMDV_phased_vcf_merged_renamed_080624.vcf Chile_PMDV_phased_vcf_merged_080624.vcf
