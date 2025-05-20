#/bin/bash
#SOBREIRA LAB WES PIPELINE v1.0
#09.15.2023
#RENAN PAULO MARTIN
#rmart120@jhmi.edu

GATK_DIR="/scratch/PIPELINE/TOOLS/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef"
REF_GENOME="/scratch/PIPELINE/TOOLS/FILES/human_g1k_v37_decoy.fasta"
DBSNP="${GATK_DIR}/../FILES/dbsnp_138.b37.vcf"
DIR=$1
WD_DIR_CA="${DIR}/COVERAGE"
GVCF_LIST="/niroData/BASE_CIENTIFICA/PIPELINE/GVCF_LIST.list"
PREFIX=$2
BAM_LIST="${DIR}/bams.list"

JAVA_DIR="/usr/java/jdk1.8.0_241-amd64/jre/bin"

mkdir ${WD_DIR_CA}

cd ${WD_DIR_CA}

BAIT_BED="${GATK_DIR}/../FILES/Baits_BED_File_Agilent_51Mb_v4_S03723314_ALL_Merged_111912_NOCHR.bed"
TARGET_BED=="${GATK_DIR}/../FILES/Targets_BED_File_Agilent_51Mb_v4_S03723314_OnTarget_NoCHR_082812.bed"





${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T DepthOfCoverage -R ${REF_GENOME} -I ${BAM_LIST} -L ${TARGET_BED} -o ${PREFIX}_TARGET
${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T DepthOfCoverage -R ${REF_GENOME} -I ${BAM_LIST} -L ${BAIT_BED} -o ${PREFIX}_GENE
