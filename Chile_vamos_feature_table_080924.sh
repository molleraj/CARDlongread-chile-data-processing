#!/bin/bash
# request interactive node with 32 CPUs and 32GB RAM
sinteractive --cpus-per-task=32 --mem=32g
module load bedtools
# load conda environment
source /data/$USER/conda/etc/profile.d/conda.sh
conda activate tryvamos
# python ~/vamos/tryvamos/tryvamos.py combineVCF Chile_vamos_vcfs_073024.txt /data/CARD_AUX/LRS_temp/CHILE/VAMOS/Chile_vamos_combined_073024.vcf
# make feature matrix
python ~/vamos/tryvamos/tryvamos.py quickFeature /data/CARD_AUX/LRS_temp/CHILE/VAMOS/Chile_vamos_combined_073024.vcf Chile_vamos_combined_feature_table_080624.tsv
# make diploid feature matrix
python ~/vamos/tryvamos/tryvamos.py quickFeature -D /data/CARD_AUX/LRS_temp/CHILE/VAMOS/Chile_vamos_combined_073024.vcf Chile_vamos_combined_feature_table_diploid_080924.tsv
# subset features that match pathogenic repeats
bedtools intersect -header -wa -b /data/CARDPB/data/adaptive_sampling/Madison_repeat/VAMOS/vamos_motif_pathogenic_comparison/hg38-disease-tr_FGF14.bed -a Chile_vamos_combined_feature_table_diploid_080924.tsv > Chile_vamos_combined_feature_table_diploid_pathogenic_080924.tsv
