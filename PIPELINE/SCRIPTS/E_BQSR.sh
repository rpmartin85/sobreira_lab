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
DBSNP="${GATK_DIR}/../FILES/dbsnp_138.b37.vcf"
BAIT_BED="${GATK_DIR}/../FILES/Baits_BED_File_HSobreira_Q132467_CustomBait_hg19_merged_noChr_230727.bed"

JAVA_DIR="/usr/java/jdk1.8.0_241-amd64/jre/bin"

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T BaseRecalibrator -I ${WD_DIR}/${SM_TAG}_realign.bam -R ${REF_GENOME} -knownSites $KNOWN_INDEL_1 -knownSites $KNOWN_INDEL_2 -knownSites ${DBSNP} -L ${BAIT_BED} -nct 4 -o ${WD_DIR}/${SM_TAG}_BQRS.bqsr


