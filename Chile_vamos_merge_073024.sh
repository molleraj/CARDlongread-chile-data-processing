#!/bin/bash
# request interactive node with 32 CPUs and 32GB RAM
sinteractive --cpus-per-task=32 --mem=32g
# load conda environment
source /data/$USER/conda/etc/profile.d/conda.sh
conda activate tryvamos
python ~/vamos/tryvamos/tryvamos.py combineVCF Chile_vamos_vcfs_073024.txt /data/CARD_AUX/LRS_temp/CHILE/VAMOS/Chile_vamos_combined_073024.vcf
