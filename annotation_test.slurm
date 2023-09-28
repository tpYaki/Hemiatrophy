#!/bin/bash
#SBATCH -J exac_anno
#SBATCH -N 4  # 选择计算节点数量
#SBATCH -p normal  # 选择计算节点分区
#SBATCH -o vep_annotation.out  # 指定输出文件

source deactivate
conda activate vep

# 输入文件所在目录
input_dir="/public/home/chenzefu/benchmark/output_files"

# 输出文件目录
output_dir="/public/home/chenzefu/benchmark/Exac_annotated"

# 创建输出文件目录
mkdir -p "$output_dir"

# 列出输入文件目录中的所有 VCF 文件
input_files=("$input_dir"/*.vcf.gz)

# 获取节点数
num_nodes=$SLURM_NNODES

# 计算每个节点分配的文件数量
files_per_node=$(((${#input_files[@]} + $num_nodes - 1) / $num_nodes))

# 计算文件分割的起始和结束索引
start_idx=$((($SLURM_NODEID * $files_per_node)))
end_idx=$((($SLURM_NODEID * $files_per_node + $files_per_node - 1)))

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
# 等待所有任务完成
wait

echo "注释完成！"
conda deactivate
