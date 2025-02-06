#!/usr/bin/env bash

#SBATCH --partition=norm
#SBATCH --cpus-per-task=32
#SBATCH --mem=32g
#SBATCH --time=5:00:00
#SBATCH --gres=lscratch:10
#SBATCH --mail-type=BEGIN,TIME_LIMIT_90,END

#NEED TO CHANGE HERE
BASE_DIR=/data/CARD_AUX/LRS_temp/CHILE
SAMPLE_SHEET='/data/CARD_AUX/LRS_temp/CHILE/WES_BAM/WES_BAM_IDs_list_012325.txt'

# add merged BAM directory
# mkdir -p ${BASE_DIR}/ONT_UBAM_CARDPB/

N=${SLURM_ARRAY_TASK_ID}

# get BAM sample ID from sample sheet
BAM_ID=$(sed -n ${N}p $SAMPLE_SHEET)

# load samtools merge command to merge individual BAMs per sample
ml samtools

# merge BAMs for sample in WES_BAM subdirectory
mkdir -p ${BASE_DIR}/WES_BAM/MERGED
samtools merge ${BASE_DIR}/WES_BAM/MERGED/${BAM_ID}_merged.bam ${BASE_DIR}/WES_BAM/*/${BAM_ID}*.bam
