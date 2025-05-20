#/bin/bash
#SOBREIRA LAB WES PIPELINE v1.0
#09.15.2023
#RENAN PAULO MARTIN
#rmart120@jhmi.edu

GATK_DIR="/scratch/PIPELINE/TOOLS/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef"
SM_TAG=${1}
REF_GENOME="/scratch/PIPELINE/TOOLS/FILES/human_g1k_v37_decoy.fasta"
WD_DIR=$2

KNOWN_INDEL_1="${GATK_DIR}/../FILES/1000G_phase1.indels.b37.vcf.gz"
KNOWN_INDEL_2="${GATK_DIR}/../FILES/Mills_and_1000G_gold_standard.indels.b37.vcf.gz"

JAVA_DIR="/usr/java/jdk1.8.0_241-amd64/jre/bin"

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T RealignerTargetCreator -I ${WD_DIR}/${SM_TAG}_dup.bam -R ${REF_GENOME} -known $KNOWN_INDEL_1 -known $KNOWN_INDEL_2 -dt NONE -nt 4 -o ${WD_DIR}/${SM_TAG}_LOCAL_REALIGNMENT_INTERVALS.intervals

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T IndelRealigner -I ${WD_DIR}/${SM_TAG}_dup.bam -R ${REF_GENOME} -known $KNOWN_INDEL_1 -known $KNOWN_INDEL_2 -targetIntervals ${WD_DIR}/${SM_TAG}_LOCAL_REALIGNMENT_INTERVALS.intervals -dt NONE -o ${WD_DIR}/${SM_TAG}_realign.bam

