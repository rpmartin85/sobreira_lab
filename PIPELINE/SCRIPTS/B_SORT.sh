#/bin/bash
#SOBREIRA LAB WES PIPELINE v1.0
#09.15.2023
#RENAN PAULO MARTIN
#rmart120@jhmi.edu

GATK_DIR="/scratch/PIPELINE/TOOLS/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef"
SM_TAG=${1}
WD_DIR=$2

java -jar ${GATK_DIR}/picard.jar SortSam --INPUT ${WD_DIR}/${SM_TAG}_original.bam --OUTPUT ${WD_DIR}/${SM_TAG}_original_sorted.bam --VALIDATION_STRINGENCY SILENT --SORT_ORDER coordinate --CREATE_INDEX true
