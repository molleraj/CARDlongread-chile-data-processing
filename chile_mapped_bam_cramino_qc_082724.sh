#!/usr/bin/bash
#SBATCH --cpus-per-task=32
#SBATCH --mem=32g
#SBATCH --mail-type=BEGIN,TIME_LIMIT_90,END
#SBATCH --time=8:00:00

#NEED TO CHANGE HERE
BASE_DIR=/data/CARD_AUX/LRS_temp/CHILE
SAMPLE_SHEET='/data/CARD_AUX/LRS_temp/CHILE/SCRIPTS/CHILE_SAMPLE_FLOWCELL.tsv'

# add merged BAM directory
mkdir -p ${BASE_DIR}/ONT_UBAM/MERGED

N=${SLURM_ARRAY_TASK_ID}

SAMPLE_ID=$(sed -n ${N}p $SAMPLE_SHEET | cut -f 1)
FLOWCELL=$(sed -n ${N}p $SAMPLE_SHEET | cut -f 2)

echo "Job Array #${N}"
echo "SAMPLE_ID ${SAMPLE_ID}"
echo "FLOWCELL ${FLOWCELL}"

# get statistics with cramino
# load nanopack module
module load nanopack
cramino -t 32 --reference /data/CARDPB/resources/hg38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa ${BASE_DIR}/MAPPED_BAM/${SAMPLE_ID}.sorted_meth.bam > ${BASE_DIR}/MAPPED_BAM/${SAMPLE_ID}_cramino_QC.txt
