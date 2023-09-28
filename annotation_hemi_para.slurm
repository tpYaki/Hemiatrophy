#!/bin/bash
#SBATCH -J exac_anno
#SBATCH -N 1  # 选择计算节点数量（这里设置为1，因为你将为每组染色体提交一个作业）
#SBATCH -p normal  # 选择计算节点分区
conda activate vep

# 输入文件所在目录
input_dir="/public/home/chenzefu/benchmark/DATA"

# 输出文件目录
output_dir="/public/home/chenzefu/benchmark/hemi_annotated"

# 创建输出文件目录
mkdir -p "$output_dir"

# 列出输入文件目录中的所有 VCF 文件
input_files=("$input_dir"/*.vcf.gz)

# 总分组数
total_groups=$1

# 要处理的分组编号
group_index=$2

# 确保输入参数合法
if [ $group_index -lt 1 ] || [ $group_index -gt $total_groups ]; then
    echo "分组编号超出范围"
    exit 1
fi

# 计算每个分组包含的文件数
files_per_group=$(((${#input_files[@]} + $total_groups - 1) / $total_groups))

# 计算文件分组的起始和结束索引
start_idx=$((($group_index - 1) * $files_per_group))
end_idx=$((($group_index * $files_per_group - 1)))

# 处理当前分组的文件
for ((i = $start_idx; i <= $end_idx; i++)); do
    if [[ $i -lt ${#input_files[@]} ]]; then
        input_file="${input_files[$i]}"
        filename=$(basename "$input_file")
        vep --cache --dir_cache /public/home/chenzefu/benchmark/ensembl-vep --input_file "$input_file" --output_file "$output_dir/$filename.annotated.vcf" --plugin AlphaMissense,file=/public/home/chenzefu/benchmark/ensembl-vep/AlphaMissense/AlphaMissense_hg19.tsv.gz,transcript_match=1 --format vcf \
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
    fi
done

echo "分组 $group_index 处理完成。"

