#/bin/bash
#SOBREIRA LAB WES PIPELINE v1.0
#09.15.2023
#RENAN PAULO MARTIN
#rmart120@jhmi.edu

ANNOVAR='/scratch/annovar/'

WD=$1

VCF=$2

${ANNOVAR}/convert2annovar.pl -format vcf4 ${WD}/${VCF}.vcf --includeinfo -withzyg -out ${WD}/${VCF}.avinput

${ANNOVAR}/table_annovar.pl ${WD}/${VCF}.avinput ${ANNOVAR}/humandb/ \
-buildver hg19 -otherinfo -out ${WD}/${VCF} -remove \
-protocol refGene,knownGene,ensGene,dbnsfp42a,dbnsfp31a_interpro,dbscsnv11,intervar_20180118,cosmic70,exac03,gnomad211_exome,gnomad211_genome,kaviar_20150923,abraom,revel,avsnp150,clinvar_20221231,cadd13 \
-operation g,g,g,f,f,f,f,f,f,f,f,f,f,f,f,f,f
