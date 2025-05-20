#/bin/bash
#SOBREIRA LAB WES PIPELINE v1.0
#09.15.2023
#RENAN PAULO MARTIN
#rmart120@jhmi.edu

GATK_DIR="/scratch/PIPELINE/TOOLS/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef"
REF_GENOME="/scratch/PIPELINE/TOOLS/FILES/human_g1k_v37_decoy.fasta"
DBSNP="${GATK_DIR}/../FILES/dbsnp_138.b37.vcf"
BAIT_BED="${GATK_DIR}/../FILES/Baits_BED_File_Agilent_51Mb_v4_S03723314_ALL_Merged_111912_NOCHR.bed"
TARGET_BED=="${GATK_DIR}/../FILES/Targets_BED_File_Agilent_51Mb_v4_S03723314_OnTarget_NoCHR_082812.bed"
DIR=$1
WD_DIR_JC=${DIR}/MSVCF
GVCF_LIST=$3
PREFIX=$2

JAVA_DIR="/usr/java/jdk1.8.0_241-amd64/jre/bin"

mkdir ${WD_DIR_JC}

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T CombineGVCFs -R ${REF_GENOME} --variant $GVCF_LIST -L ${BAIT_BED} --disable_auto_index_creation_and_locking_when_reading_rods  \
-o ${WD_DIR_JC}/${PREFIX}.genomes.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T GenotypeGVCFs -R ${REF_GENOME} --annotateNDA --variant ${WD_DIR_JC}/${PREFIX}.genomes.vcf --disable_auto_index_creation_and_locking_when_reading_rods  \
-o ${WD_DIR_JC}/${PREFIX}.tmp.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T VariantAnnotator -R ${REF_GENOME} --variant ${WD_DIR_JC}/${PREFIX}.tmp.vcf --dbsnp $DBSNP -L ${BAIT_BED} -A GCContent -A VariantType --disable_auto_index_creation_and_locking_when_reading_rods  \
-o ${WD_DIR_JC}/${PREFIX}.raw.HC.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T SelectVariants -R ${REF_GENOME} -selectType SNP --disable_auto_index_creation_and_locking_when_reading_rods  --variant ${WD_DIR_JC}/${PREFIX}.raw.HC.vcf -o ${WD_DIR_JC}/${PREFIX}.raw.HC.SNV.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T SelectVariants -R ${REF_GENOME} -selectType INDEL -selectType MNP -selectType MIXED -selectType SYMBOLIC --disable_auto_index_creation_and_locking_when_reading_rods  --variant ${WD_DIR_JC}/${PREFIX}.raw.HC.vcf -o ${WD_DIR_JC}/${PREFIX}.raw.HC.INDEL.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T VariantRecalibrator -R ${REF_GENOME} --input:VCF ${WD_DIR_JC}/${PREFIX}.raw.HC.SNV.vcf \
-resource:hapmap,known=false,training=true,truth=true,prior=15.0 ${GATK_DIR}/Resources/hapmap_3.3.b37.vcf \
-resource:omni,known=false,training=true,truth=true,prior=12.0 ${GATK_DIR}/Resources/1000G_omni2.5.b37.vcf \
-resource:1000G,known=false,training=true,truth=false,prior=10.0 ${GATK_DIR}/Resources/1000G_phase1.snps.high_confidence.b37.vcf \
-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 ${GATK_DIR}/Resources/dbsnp_138.b37.vcf \
-mode SNP \
--disable_auto_index_creation_and_locking_when_reading_rods \
-an QD \
-an SOR \
-an MQRankSum \
-an ReadPosRankSum \
-an FS \
-tranche 100.0 \
-tranche 99.9 \
-tranche 99.8 \
-tranche 99.7 \
-tranche 99.6 \
-tranche 99.5 \
-tranche 99.4 \
-tranche 99.3 \
-tranche 99.2 \
-tranche 99.1 \
-tranche 99.0 \
-tranche 98.0 \
-tranche 97.0 \
-tranche 96.0 \
-tranche 95.0 \
-tranche 90.0 \
-recalFile ${WD_DIR_JC}/${PREFIX}.HC.SNV.recal \
-tranchesFile ${WD_DIR_JC}/${PREFIX}.HC.SNV.tranches \
-rscriptFile ${WD_DIR_JC}/${PREFIX}.HC.SNV.R


${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T VariantRecalibrator -R ${REF_GENOME} --input:VCF ${WD_DIR_JC}/${PREFIX}.raw.HC.INDEL.vcf \
-resource:mills,known=true,training=true,truth=true,prior=12.0 ${GATK_DIR}/Resources/Mills_and_1000G_gold_standard.indels.b37.vcf \
--maxGaussians 4 \
--disable_auto_index_creation_and_locking_when_reading_rods \
-an MQRankSum \
-an FS \
-an SOR \
-an ReadPosRankSum \
-an QD \
-mode INDEL \
-tranche 100.0 \
-tranche 99.9 \
-tranche 99.8 \
-tranche 99.7 \
-tranche 99.6 \
-tranche 99.5 \
-tranche 99.4 \
-tranche 99.3 \
-tranche 99.2 \
-tranche 99.1 \
-tranche 99.0 \
-tranche 98.0 \
-tranche 97.0 \
-tranche 96.0 \
-tranche 95.0 \
-tranche 90.0 \
-recalFile ${WD_DIR_JC}/${PREFIX}.HC.INDEL.recal \
-tranchesFile ${WD_DIR_JC}/${PREFIX}.HC.INDEL.tranches \
-rscriptFile ${WD_DIR_JC}/${PREFIX}.HC.INDEL.R


${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T ApplyRecalibration -R ${REF_GENOME} --disable_auto_index_creation_and_locking_when_reading_rods  \
--input:VCF ${WD_DIR_JC}/${PREFIX}.raw.HC.SNV.vcf --ts_filter_level 99.9 \
-recalFile ${WD_DIR_JC}/${PREFIX}.HC.SNV.recal \
-tranchesFile ${WD_DIR_JC}/${PREFIX}.HC.SNV.tranches \ 
-mode SNP -o ${WD_DIR_JC}/${PREFIX}.HC.SNV.VQSR.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T ApplyRecalibration -R ${REF_GENOME} --disable_auto_index_creation_and_locking_when_reading_rods  \
--input:VCF ${WD_DIR_JC}/${PREFIX}.raw.HC.INDEL.vcf --ts_filter_level 99.9 \
-recalFile ${WD_DIR_JC}/${PREFIX}.HC.INDEL.recal \
-tranchesFile ${WD_DIR_JC}/${PREFIX}.HC.INDEL.tranches \ 
-mode INDEL -o ${WD_DIR_JC}/${PREFIX}.HC.INDEL.VQSR.vcf

${JAVA_DIR}/java -jar ${GATK_DIR}/GenomeAnalysisTK.jar -T CombineVariants -R $REF_GENOME \
--variant -o ${WD_DIR_JC}/${PREFIX}.HC.SNV.VQSR.vcf \
--variant -o ${WD_DIR_JC}/${PREFIX}.HC.INDEL.VQSR.vcf \
--disable_auto_index_creation_and_locking_when_reading_rods \
-o ${WD_DIR_JC}/${PREFIX}.MS.BEDsuperset.VQSR.vcf
