#/bin/bash
#SOBREIRA LAB WES PIPELINE v1.0
#09.15.2023
#RENAN PAULO MARTIN
#rmart120@jhmi.edu

GATK_DIR="/scratch/PIPELINE/TOOLS/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef"
SM_TAG=${1}
REF_GENOME="/scratch/PIPELINE/TOOLS/FILES/human_g1k_v37_decoy.fasta"
WD_DIR=$2
DBSNP="${GATK_DIR}/../FILES/dbsnp_138.b37.vcf"
BAIT_BED="${GATK_DIR}/../FILES/Baits_BED_File_Agilent_51Mb_v4_S03723314_ALL_Merged_111912_NOCHR.bed"
TARGET_BED=="${GATK_DIR}/../FILES/Targets_BED_File_Agilent_51Mb_v4_S03723314_OnTarget_NoCHR_082812.bed"

JAVA_DIR="/usr/java/jdk1.8.0_241-amd64/jre/bin"

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T HaplotypeCaller -R ${REF_GENOME} --input_file ${WD_DIR}/${SM_TAG}_final.bam -L ${BAIT_BED} \
--emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -A DepthPerSampleHC -A ClippingRankSumTest \
-A MappingQualityRankSumTest -A ReadPosRankSumTest -A FisherStrand -A GCContent -A AlleleBalanceBySample -A AlleleBalance \
-A QualByDepth -pairHMM VECTOR_LOGLESS_CACHING -o ${WD_DIR}/${SM_TAG}.genome.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T GenotypeGVCFs -R ${REF_GENOME} --variant ${WD_DIR}/${SM_TAG}.genome.vcf -o ${WD_DIR}/${SM_TAG}_QC_RAW_OnBait.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T SelectVariants -R ${REF_GENOME} --variant ${WD_DIR}/${SM_TAG}_QC_RAW_OnBait.vcf -selectType SNP --excludeFiltered -o ${WD_DIR}/${SM_TAG}_QC_RAW_OnBait_SNV.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T VariantAnnotator -R ${REF_GENOME} --variant ${WD_DIR}/${SM_TAG}_QC_RAW_OnBait_SNV.vcf --dbsnp $DBSNP -L ${BAIT_BED} -A GCContent -A VariantType -o ${WD_DIR}/${SM_TAG}_QC_RAW_OnBait_SNV_ANNOTATED.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T VariantFiltration \
-R ${REF_GENOME} --variant ${WD_DIR}/${SM_TAG}_QC_RAW_OnBait_SNV_ANNOTATED.vcf \
--filterExpression 'QD < 2.0' --filterName 'QD' --filterExpression 'MQ < 30.0' --filterName 'MQ' \
--filterExpression 'FS > 40.0' --filterName 'FS' --filterExpression 'MQRankSum < -12.5' --filterName 'MQRankSum' \
--filterExpression 'ReadPosRankSum < -8.0' --filterName 'ReadPosRankSum' --filterExpression 'DP < 8.0' \
--filterName 'DP' --logging_level ERROR -o ${WD_DIR}/${SM_TAG}_QC_FILTERED_OnBait_SNV.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T SelectVariants \
-R ${REF_GENOME} --variant ${WD_DIR}/${SM_TAG}_QC_FILTERED_OnBait_SNV.vcf \
--excludeFiltered -o ${WD_DIR}/${SM_TAG}_QC_OnBait.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T SelectVariants -R ${REF_GENOME} \
--variant ${WD_DIR}/${SM_TAG}_QC_OnBait.vcf -L ${TARGET_BED} -o ${WD_DIR}/${SM_TAG}_QC_OnTarget.vcf
