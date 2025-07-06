#!/bin/bash
#SBATCH --job-name=EGR1
#SBATCH --error=/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/EGR1/manorm/manorm_EGR1_%A%a.err
#SBATCH --output=/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/EGR1/manorm/manorm_EGR1_%A%a.out
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=60:00:00
#SBATCH --mail-user=a.theodosiadou@amsterdamumc.nl
#SBATCH --mail-type=END,FAIL
#SBATCH --array=1-3


# # Define conditions array
conditions=("IL4" "LPS+IL4" "LPS")
# # Get current condition
condition=${conditions[$SLURM_ARRAY_TASK_ID-1]}
echo "Running for condition: ${condition}"

INPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/EGR1/narrowPeak"
OUTPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/EGR1/manorm/${condition}_ctrl"

# # Create output directories
mkdir -p "${OUTPUT_PATH}"

echo "Processing condition: ${condition}"

# Process all donors
echo "Processing all donors for condition ${condition}"
manorm --p1 "${INPUT_PATH}/mph_272_${condition}_EGR1.macs3_peaks.narrowPeak" \
       --p2 "${INPUT_PATH}/mph_272_ctrl_EGR1.macs3_peaks.narrowPeak" \
       --pf narrowpeak \
       --r1 "${INPUT_PATH}/mph-272-ChIP-${condition}-EGR1_S1_L001_trimmed_filtered.bam" \
       --r2 "${INPUT_PATH}/mph-272-ChIP-ctrl-EGR1_S1_L001_trimmed_filtered.bam" \
       --rf bam \
       --pe \
       -o "${OUTPUT_PATH}" \
       --wa






# #!/bin/bash
# #SBATCH --job-name=manorm_EGR1
# #SBATCH --error=/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/EGR1/manorm/manorm_EGR1_%A%a.err
# #SBATCH --output=/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/EGR1/manorm/manorm_EGR1_%A%a.out
# #SBATCH --ntasks=1
# #SBATCH --cpus-per-task=16
# #SBATCH --time=60:00:00
# #SBATCH --mail-user=a.theodosiadou@amsterdamumc.nl
# #SBATCH --mail-type=END,FAIL
# #SBATCH --array=1-3

# # Define conditions array
# conditions=("LPS+IL4" "LPS" "IL4")

# # Get current condition
# condition=${conditions[$SLURM_ARRAY_TASK_ID-1]}

# INPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/EGR1"
# OUTPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/EGR1/manorm/${condition}_ctrl"

# # Create output directories
# mkdir -p "${OUTPUT_PATH}"

# echo "Processing condition: ${condition}"

# # Process all donors
# echo "Processing all donors for condition ${condition}"
# manorm --p1 "${INPUT_PATH}/EGR1_${condition}.macs3_peaks_filtered.narrowPeak" \
#        --p2 "${INPUT_PATH}/EGR1_ctrl.macs3_peaks_filtered.narrowPeak" \
#        --pf narrowpeak \
#        --r1 "${INPUT_PATH}/EGR1_${condition}_merged.bam" \
#        --r2 "${INPUT_PATH}/EGR1_ctrl_merged.bam" \
#        --rf bam \
#        --pe \
#        -o "${OUTPUT_PATH}" \
#        --wa


