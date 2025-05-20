#/bin/bash
#SOBREIRA LAB WES PIPELINE v1.0
#09.15.2023
#RENAN PAULO MARTIN
#rmart120@jhmi.edu

GATK_DIR="/scratch/PIPELINE/TOOLS/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef"
SM_TAG=${1}
REF_GENOME="/scratch/PIPELINE/TOOLS/FILES/human_g1k_v37_decoy.fasta"
WD_DIR=$2

JAVA_DIR="/usr/java/jdk1.8.0_241-amd64/jre/bin"

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T PrintReads -R ${REF_GENOME} -I ${WD_DIR}/${SM_TAG}_realign.bam -BQSR ${WD_DIR}/${SM_TAG}_BQRS.bqsr -dt NONE -EOQ -nct 8 -o ${WD_DIR}/${SM_TAG}_final.bam
