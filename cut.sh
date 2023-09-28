#!/bin/bash

# 大的输入 VCF 文件
input_vcf="/public/home/chenzefu/benchmark/ExAC.r1.sites.vep.vcf.gz"


# 输出目录
output_dir="/public/home/chenzefu/benchmark/output_files"

mkdir -p "$output_dir"

# 使用 bcftools query 获取所有不同的染色体
chromosomes=($(tabix -l "$input_vcf"))

# 循环处理每个染色体
for chrom in "${chromosomes[@]}"; do
    echo "处理染色体: $chrom"
    
    output_file="$output_dir/Exac_$chrom.vcf.gz"

    # 使用 bcftools view 分割 VCF 文件
    bcftools view -Oz -o "$output_file" -r "$chrom" "$input_vcf"

    # 为子文件生成索引文件
    bcftools index -t "$output_file"
done

echo "分割完成，子文件保存在 $output_dir 目录中。"

