#!/bin/bash
#SBATCH -J exac_anno
source deactivate
conda activate vep
vep --cache --dir_cache /public/home/chenzefu/benchmark/ensembl-vep --input_file /public/home/chenzefu/benchmark/ExAC.r1.sites.vep.vcf.gz --output_file /public/home/chenzefu/benchmark/output.vcf --plugin AlphaMissense,file=/public/home/chenzefu/benchmark/ensembl-vep/AlphaMissense/AlphaMissense_hg19.tsv.gz,transcript_match=1 --format vcf \
        --force_overwrite \
        --offline \
        --assembly GRCh37 \
        --vcf \
        --symbol \
        --no_stats \
        --minimal \
        --no_escape \
        --terms SO \
        --pick
conda deactivate
