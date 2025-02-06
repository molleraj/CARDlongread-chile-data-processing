#!/bin/bash
# request interactive node with 32 CPUs and 32GB RAM
# sinteractive --cpus-per-task=32 --mem=32g
# never mind - run as a batch job
#SBATCH --cpus-per-task=32
#SBATCH --mem=32g
#SBATCH --time=2:00:00
# load conda environment
source /data/$USER/conda/etc/profile.d/conda.sh
conda activate tryvamos
python ~/vamos/tryvamos/tryvamos.py combineVCF Chile_pathogenic_vamos_vcfs_102524.txt /data/CARD_AUX/LRS_temp/CHILE/VAMOS/Chile_pathogenic_vamos_combined_102524.vcf
