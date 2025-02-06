#!/bin/bash

#SBATCH --partition=gpu
#SBATCH --cpus-per-task=64
#SBATCH --mem=100g
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

module load deepvariant

mkdir -p ${BASE_DIR}/DeepVariant

BAM=${BASE_DIR}/MAPPED_BAM/${SAMPLE_ID}.sorted_meth.bam
OUT_FOLDER=${BASE_DIR}/DeepVariant/${SAMPLE_ID}
SAMPLE_PREFIX=${SAMPLE_ID}

# cp -r $PEPPER_DATA/* .

run_deepvariant \
--model_type=ONT_R104 \
--ref=/data/CARDPB/resources/hg38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa \
--reads=${BAM} \
--sample_name=${SAMPLE_PREFIX} \
--output_vcf=${OUT_FOLDER}/${SAMPLE_PREFIX}.vcf.gz \
--output_gvcf=${OUT_FOLDER}/${SAMPLE_PREFIX}.g.vcf.gz \
--intermediate_results_dir=${OUT_FOLDER}/intermediate_results_dir \
--logging_dir=${OUT_FOLDER}/logs \
--call_variants_extra_args="writer_threads=2" \
--num_shards=64

# __________________________________________________________________________________________________

# INDEX PHASED BAM
# module load samtools
# samtools index ${OUT_FOLDER}/${SAMPLE_PREFIX}.haplotagged.bam
