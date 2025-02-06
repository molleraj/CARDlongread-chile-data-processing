#!/usr/bin/env bash

#SBATCH --partition=gpu
#SBATCH --cpus-per-task=30
#SBATCH --mem=60g
#SBATCH --mail-type=BEGIN,TIME_LIMIT_90,END
#SBATCH --time=96:00:00
#SBATCH --gres=lscratch:50,gpu:v100x:2

N=${SLURM_ARRAY_TASK_ID}
SAMPLE_SHEET='/data/CARD_AUX/LRS_temp/CHILE/SCRIPTS/CHILE_SAMPLE_FLOWCELL.tsv'
SAMPLE_ID=$(sed -n ${N}p $SAMPLE_SHEET | cut -f 1)
FLOWCELL=$(sed -n ${N}p $SAMPLE_SHEET | cut -f 2)

echo "Job Array #${N}"
echo "SAMPLE_ID ${SAMPLE_ID}"
echo "FLOWCELL ${FLOWCELL}"

BASE_DIR=/data/CARD_AUX/LRS_temp/CHILE

mkdir -p ${BASE_DIR}/ONT_UBAM/${SAMPLE_ID}

module load dorado/0.7.1
module load pod5

# Basecall
echo "${BASE_DIR}/ONT_UBAM/${SAMPLE_ID}/${SAMPLE_ID}_${FLOWCELL}_pod5.5mCG_5hmCG_v5.0.0.bam"
dorado basecaller -x cuda:all ${DORADO_MODELS}/dna_r10.4.1_e8.2_400bps_sup@v5.0.0 ${BASE_DIR}/POD5/${SAMPLE_ID}/${FLOWCELL} --skip-model-compatibility-check --modified-bases 5mCG_5hmCG > ${BASE_DIR}/ONT_UBAM/${SAMPLE_ID}/${SAMPLE_ID}_${FLOWCELL}_pod5.5mCG_5hmCG_v5.0.0.bam

# Summary
echo "${BASE_DIR}/ONT_UBAM/${SAMPLE_ID}/${SAMPLE_ID}_${FLOWCELL}_sequencing_summary_v5.0.0.txt"
dorado summary ${BASE_DIR}/ONT_UBAM/${SAMPLE_ID}/${SAMPLE_ID}_${FLOWCELL}_pod5.5mCG_5hmCG_v5.0.0.bam > ${BASE_DIR}/ONT_UBAM/${SAMPLE_ID}/${SAMPLE_ID}_${FLOWCELL}_sequencing_summary_v5.0.0.txt
