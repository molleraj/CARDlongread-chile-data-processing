#!/bin/bash
#SBATCH --cpus-per-task=32
#SBATCH --mem=32g
#SBATCH --time=1:00:00
# just run as batch job
# request interactive node with 32 CPUs and 32GB RAM
# sinteractive --cpus-per-task=32 --mem=32g
module load bedtools
# load conda environment
source /data/$USER/conda/etc/profile.d/conda.sh
conda activate tryvamos
# python ~/vamos/tryvamos/tryvamos.py combineVCF Chile_pathogenic_vamos_vcfs_102524.txt /data/CARD_AUX/LRS_temp/CHILE/VAMOS/Chile_pathogenic_vamos_combined_102524.vcf
# make feature matrix
python ~/vamos/tryvamos/tryvamos.py quickFeature /data/CARD_AUX/LRS_temp/CHILE/VAMOS/Chile_pathogenic_vamos_combined_102524.vcf Chile_pathogenic_vamos_combined_feature_table_102524.tsv
# make diploid feature matrix
python ~/vamos/tryvamos/tryvamos.py quickFeature -D /data/CARD_AUX/LRS_temp/CHILE/VAMOS/Chile_pathogenic_vamos_combined_102524.vcf Chile_pathogenic_vamos_combined_feature_table_diploid_102524.tsv
# subset features that match pathogenic repeats
bedtools intersect -header -wa -b /data/CARDPB/data/adaptive_sampling/Madison_repeat/VAMOS/vamos_motif_pathogenic_comparison/hg38-disease-tr_FGF14.bed -a Chile_pathogenic_vamos_combined_feature_table_diploid_102524.tsv > Chile_pathogenic_vamos_combined_feature_table_diploid_pathogenic_102524.tsv
