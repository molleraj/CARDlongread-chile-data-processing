#!/usr/bin/bash
#SBATCH --cpus-per-task=40
#SBATCH --mem=120g
#SBATCH --mail-type=BEGIN,TIME_LIMIT_90,END
#SBATCH --time=96:00:00


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


echo "map with minimap2"
module load minimap2
module load samtools

mkdir -p ${BASE_DIR}/MAPPED_BAM/${SAMPLE_ID}

BAM_NUMBER=$(ls ${BASE_DIR}/ONT_UBAM/${SAMPLE_ID}/*.bam | wc -l)
if [ ${BAM_NUMBER} != 1 ];then
        BAMS=$(ls ${BASE_DIR}/ONT_UBAM/${SAMPLE_ID}/*.bam)
        samtools merge --threads 4 ${BASE_DIR}/ONT_UBAM/MERGED/${SAMPLE_ID}_merged.bam $BAMS
        samtools index ${BASE_DIR}/ONT_UBAM/MERGED/${SAMPLE_ID}_merged.bam
    else
        cp ${BASE_DIR}/ONT_UBAM/${SAMPLE_ID}/*.bam ${BASE_DIR}/ONT_UBAM/MERGED/${SAMPLE_ID}_merged.bam
        samtools index ${BASE_DIR}/ONT_UBAM/MERGED/${SAMPLE_ID}_merged.bam
    fi

samtools fastq -TMM,ML ${BASE_DIR}/ONT_UBAM/MERGED/${SAMPLE_ID}_merged.bam |  minimap2 -y -x map-ont --MD -t 20 -a --eqx -k 17 -K 10g /data/CARDPB/resources/hg38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa - | samtools view -@ 10 -bh - | samtools sort -@ 10 - > ${BASE_DIR}/MAPPED_BAM/${SAMPLE_ID}.sorted_meth.bam

samtools index ${BASE_DIR}/MAPPED_BAM/${SAMPLE_ID}.sorted_meth.bam

# get statistics with cramino
module load cramino
cramino -t 32 --reference /data/CARDPB/resources/hg38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fa ${BASE_DIR}/MAPPED_BAM/${SAMPLE_ID}.sorted_meth.bam > ${BASE_DIR}/MAPPED_BAM/${SAMPLE_ID}_cramino_QC.txt
