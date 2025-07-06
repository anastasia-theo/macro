#!/bin/bash
#SBATCH --job-name=bed_intersect
#SBATCH --error=/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/bed_intersect/intersect_H3K27ac_TF%A%a.err
#SBATCH --output=/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/bed_intersect/intersect_H3K27ac_TF%A%a.out
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=60:00:00
#SBATCH --mail-user=a.theodosiadou@amsterdamumc.nl
#SBATCH --mail-type=END,FAIL

condition="EGR1"
treatment="LPS"

INPUT_PATH_H3K="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/H3K27ac/manorm/LPS_ctrl/"
INPUT_PATH_TF="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/annotated_chipseeker_trial/"
OUTPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/bed_intersect/H3K27ac_${condition}_LPS"

mkdir -p "${OUTPUT_PATH}"

# Create BED file for H3K27ac, removing the header and non-numeric characters
awk 'BEGIN{FS="\t"; OFS="\t"} NR>1 {gsub(/[^0-9]/, "", $2); gsub(/[^0-9]/, "", $3); print $1, $2, $3}' "${INPUT_PATH_H3K}"/*_all_MAvalues.xls > /tmp/h3k_temp.bed

# Create BED file for TF, removing the header and non-numeric characters
awk 'BEGIN{FS="\t"; OFS="\t"} NR>1 {gsub(/[^0-9]/, "", $2); gsub(/[^0-9]/, "", $3); print $1, $2, $3}' "${INPUT_PATH_TF}"/${condition}_${treatment}*.xls > /tmp/tf_temp.bed

bedtools intersect \
    -a /tmp/h3k_temp.bed \
    -b /tmp/tf_temp.bed \
    -wao > "${OUTPUT_PATH}"/H3K27ac_${condition}_${treatment}_ctrl_overlap.bed

echo "Completed $condition $treatment"


# # #Define the directories
# conditions=("EGR1" "EGR2")
# treatments=("LPS")

# # # Get current treatment and condition

# # array_index=$((SLURM_ARRAY_TASK_ID - 1))
# # condition_index=$((array_index / 3))
# # treatment_index=$((array_index % 3))


# # condition=${condition[condition_index]}
# # treatment=${treatment[treatment_index]}
# # echo ${treatment}
# # echo ${condition}

# for condition in "${conditions[@]}"; do
#     for treatment in "${treatments[@]}"; do
#         echo "Processing intersection between H3K27ac and ${condition}_${treatment} vs ctrl"

#         INPUT_PATH_H3K="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/H3K27ac/manorm/LPS_ctrl/"
#         INPUT_PATH_TF="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/annotated_chipseeker_trial/"
#         OUTPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/bed_intersect/H3K27ac_${condition}_LPS"

#         mkdir -p "${OUTPUT_PATH}"

#         tail -n +2 "${INPUT_PATH_H3K}"/*_all_MAvalues.xls | awk 'BEGIN{FS="\t"; OFS="\t"} NR>1 {print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10}' "${INPUT_PATH_H3K}"/*_all_MAvalues.xls > "${OUTPUT_PATH}"/H3K27ac_${treatment}_vs_ctrl.bed

#         tail -n +2 "${INPUT_PATH_TF}"/${condition}_${treatment}*.xls | awk 'BEGIN{FS="\t"; OFS="\t"} 
#         NR>1 {
#             gsub(/ /, "_", $13); 
#             gsub(/ /, "_", $23); 
#             print $1,$2,$3,$6,$7,$8,$9,$10,$11,$12,$13,$20,$22,$23
#             }' "${INPUT_PATH_TF}"/${condition}_${treatment}*.xls > "${OUTPUT_PATH}"/${condition}_${treatment}_vs_ctrl.bed


#         bedtools intersect \
#             -a "${OUTPUT_PATH}"/H3K27ac_${treatment}_vs_ctrl.bed \
#             -b "${OUTPUT_PATH}"/${condition}_${treatment}_vs_ctrl.bed \
#             -wao > "${OUTPUT_PATH}"/H3K27ac_${condition}_${treatment}_ctrl_overlap.bed

#         echo "Completed $condition $treatment"
#     done
# done


