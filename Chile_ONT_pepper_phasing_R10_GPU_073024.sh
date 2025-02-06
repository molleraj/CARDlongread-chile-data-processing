#!/bin/bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=40g
#SBATCH --mail-type=BEGIN,TIME_LIMIT_90,END
#SBATCH --time=3-00:00:00
#SBATCH --gres=lscratch:300,gpu:a100:1

N=${SLURM_ARRAY_TASK_ID}
SAMPLE_SHEET='/data/CARD_AUX/LRS_temp/CHILE/SCRIPTS/CHILE_SAMPLE_FLOWCELL.tsv'
SAMPLE_ID=$(sed -n ${N}p $SAMPLE_SHEET | cut -f 1)
FLOWCELL=$(sed -n ${N}p $SAMPLE_SHEET | cut -f 2)

echo "Job Array #${N}"
echo "SAMPLE_ID ${SAMPLE_ID}"
echo "FLOWCELL ${FLOWCELL}"

BASE_DIR=/data/CARD_AUX/LRS_temp/CHILE

module load PEPPER_deepvariant

mkdir -p ${BASE_DIR}/PEPPER_phased_bam

BAM=${BASE_DIR}/MAPPED_BAM/${SAMPLE_ID}.sorted_meth.bam
OUT_FOLDER=${BASE_DIR}/PEPPER_phased_bam/${SAMPLE_ID}
SAMPLE_PREFIX=${SAMPLE_ID}

cp -r $PEPPER_DATA/* .

run_pepper_margin_deepvariant call_variant \
-b ${BAM} \
-f /data/CARDPB/resources/hg38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa \
-o ${OUT_FOLDER} \
-p ${SAMPLE_PREFIX} \
-t 8 \
-g \
--phased_output \
--ont_r10_q20

# __________________________________________________________________________________________________

# INDEX PHASED BAM
module load samtools
samtools index ${OUT_FOLDER}/${SAMPLE_PREFIX}.haplotagged.bam
