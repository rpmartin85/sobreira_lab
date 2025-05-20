#/bin/bash
#SOBREIRA LAB WES PIPELINE v1.0
#09.15.2023
#RENAN PAULO MARTIN
#rmart120@jhmi.edu

GATK_DIR="/scratch/PIPELINE/TOOLS/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef"
SM_TAG=${1}
WD_DIR=$2

JAVA_DIR="/usr/java/jdk1.8.0_241-amd64/jre/bin"

${JAVA_DIR}/java -jar ${GATK_DIR}/picard.jar MarkDuplicates --INPUT ${WD_DIR}/${SM_TAG}_original_sorted.bam --OUTPUT ${WD_DIR}/${SM_TAG}_dup.bam --VALIDATION_STRINGENCY SILENT --METRICS_FILE ${WD_DIR}/${SM_TAG}_MARK_DUPLICATES.txt --CREATE_INDEX true 

