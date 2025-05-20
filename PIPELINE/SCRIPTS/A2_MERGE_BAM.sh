#/bin/bash
#SOBREIRA LAB WES PIPELINE v1.0
#09.15.2023
#RENAN PAULO MARTIN
#rmart120@jhmi.edu

WD_DIR=$1
SM_TAG=$2

JAVA_DIR="/usr/java/jdk1.8.0_241-amd64/jre/bin"
GATK_DIR="/scratch/PIPELINE/TOOLS/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef"

FILES=$3

OUTPUT=${WD_DIR}/${SM_TAG}_original.bam

IFS=',' read -ra FILES_ARRAY <<< "${FILES}"

if [ ${#FILES_ARRAY[@]} -eq 1 ]; 
then 
    mv $FILES $OUTPUT
else 
    for i in ${FILES_ARRAY[@]}
    do
        INPUT="${INPUT}""--INPUT ${i} "
    done
    ${JAVA_DIR}/java -jar ${GATK_DIR}/picard.jar MergeSamFiles ${INPUT} --OUTPUT ${OUTPUT}
fi 

