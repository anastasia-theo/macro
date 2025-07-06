#!/bin/bash
#SBATCH --job-name=EGR2
#SBATCH --error=/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/EGR2/manorm/manorm_EGR2_%A%a.err
#SBATCH --output=/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/EGR2/manorm/manorm_EGR2_%A%a.out
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=60:00:00
#SBATCH --mail-user=a.theodosiadou@amsterdamumc.nl
#SBATCH --mail-type=END,FAIL
#SBATCH --array=1-3


# # Define conditions array
conditions=("LPS+IL4" "LPS" "IL4")
# # Get current condition
condition=${conditions[$SLURM_ARRAY_TASK_ID-1]}

INPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/EGR2/narrowPeak"
OUTPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/EGR2/manorm/${condition}_ctrl"

# # Create output directories
mkdir -p "${OUTPUT_PATH}"

echo "Processing condition: ${condition}"

# Process all donors
echo "Processing all donors for condition ${condition}"
manorm --p1 "${INPUT_PATH}/mph_272_${condition}_EGR2.macs3_peaks.narrowPeak" \
       --p2 "${INPUT_PATH}/mph_272_ctrl_EGR2.macs3_peaks.narrowPeak" \
       --pf narrowpeak \
       --r1 "${INPUT_PATH}/mph-272-ChIP-${condition}-EGR2_S1_L001_trimmed_filtered.bam" \
       --r2 "${INPUT_PATH}/mph-272-ChIP-ctrl-EGR2_S1_L001_trimmed_filtered.bam" \
       --rf bam \
       --pe \
       -o "${OUTPUT_PATH}" \
       --wa



# condition=("IL4")

# # Get current condition
# # condition=${conditions[$SLURM_ARRAY_TASK_ID-1]}

# INPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/H3K27ac/broadPeak"
# OUTPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/H3K27ac/manorm/272_${condition}_ctrl"

# # Create output directories
# mkdir -p "${OUTPUT_PATH}"

# # echo "Processing condition: ${condition}"

# # Process all donors
# echo "Processing all donors for condition ${condition}"
# manorm --p1 "${INPUT_PATH}/mph_272_IL4_H3K27ac_S1.macs3.broad_peaks.broadPeak" \
#        --p2 "${INPUT_PATH}/mph_272_ctrl_H3K27ac_S1.macs3.broad_peaks.broadPeak" \
#        --pf broadpeak \
#        --r1 "${INPUT_PATH}/mph-272-IL4-H3K27ac_S1_L001_trimmed_filtered.bam" \
#        --r2 "${INPUT_PATH}/mph-272-ctrl-H3K27ac_S1_L001_trimmed_filtered.bam" \
#        --rf bam \
#        --pe \
#        -o "${OUTPUT_PATH}" \
#        --wa