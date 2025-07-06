#!/bin/bash
#SBATCH --job-name=bed_intersect
#SBATCH --error=/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/bed_intersect/intersect_H3K27ac_TF%A%a.err
#SBATCH --output=/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/bed_intersect/intersect_H3K27ac_TF%A%a.out
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=60:00:00
#SBATCH --mail-user=a.theodosiadou@amsterdamumc.nl
#SBATCH --mail-type=END,FAIL


# #Define the directories
conditions=("EGR1" "EGR2")
treatments=("LPS+IL4" "LPS" "IL4")

# conditions=("EGR2")
# treatments=("IL4")

# # Get current treatment and condition


for treatment in "${treatments[@]}"; do
    for condition in "${conditions[@]}"; do
        echo "Processing intersection between H3K27ac and ${condition}_${treatment} vs ctrl"

        INPUT_PATH_H3K="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/H3K27ac/manorm/${treatment}_ctrl/"
        INPUT_PATH_TF="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/annotated_chipseeker_EGR/${condition}_${treatment}"
        OUTPUT_PATH="/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor/bed_intersect/H3K27ac_${condition}_${treatment}"

        mkdir -p "${OUTPUT_PATH}"

        awk 'BEGIN{FS="\t"; OFS="\t"} {print $1,$2,$3,$5,$6,$7,$8,$9,$10}' "${INPUT_PATH_H3K}"/*_sorted_auto.xls > "${OUTPUT_PATH}"/H3K27ac_${treatment}_vs_ctrl.bed

        awk 'BEGIN{FS="\t"; OFS="\t"} 
        NR>1 {
            gsub(/ /, "_", $13); 
            gsub(/ /, "_", $23); 
            print $1,$2,$3,$7,$8,$9,$10,$11,$12,$13,$20,$22,$23
            }' "${INPUT_PATH_TF}"/*_sorted.xls > "${OUTPUT_PATH}"/${condition}_${treatment}_vs_ctrl.bed


        bedtools intersect \
            -a "${OUTPUT_PATH}"/H3K27ac_${treatment}_vs_ctrl.bed \
            -b "${OUTPUT_PATH}"/${condition}_${treatment}_vs_ctrl.bed \
            -wao > "${OUTPUT_PATH}"/H3K27ac_${condition}_${treatment}_ctrl_overlap.bed

        echo "Completed $condition $treatment"
    done
done



