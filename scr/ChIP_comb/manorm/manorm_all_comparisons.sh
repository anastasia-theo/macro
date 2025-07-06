#! /bin/bash

# Use the manorm tool to identify differentially bound regions between the different samples
# Keep female and male donor peak comparisons separate

PEAKDIR="/trinity/home/adrakaki/data/ChIP_comb/trimmed_reads/mapped_reads_2/filtered_reads/donors_to_keep/merged_BAM/macs3_peaks_q_1.0e-5"
BAMDIR="/trinity/home/adrakaki/data/ChIP_comb/trimmed_reads/mapped_reads_2/filtered_reads/donors_to_keep/merged_BAM"

cd $PEAKDIR

ChIP=(EGR1 EGR2)
stims=(IL4 LPS LPS\\+IL4)

for chip in ${ChIP[@]}; do

	for stim in "${stims[@]}"; do

		stim2=$(echo "$stim" | sed 's/\\//g')

		# run for female donor peaks
		echo "Running differential binding analysis for female donor ${chip} ${stim2} peaks"

		echo "manorm --p1 female_donors_${chip}_${stim2}.macs3_peaks_filtered.narrowPeak --p2 female_donors_${chip}_ctrl.macs3_peaks_filtered.narrowPeak --r1 ${BAMDIR}/female_donors_${chip}_${stim2}_merged.bam \
			--r2 ${BAMDIR}/female_donors_${chip}_ctrl_merged.bam --n1 ${chip}_${stim2} --n2 ${chip}_ctrl --pe -o female_${chip}_${stim2}_vs_ctrl_manorm --rf bam --pf narrowpeak"

		manorm --p1 female_donors_${chip}_${stim2}.macs3_peaks_filtered.narrowPeak --p2 female_donors_${chip}_ctrl.macs3_peaks_filtered.narrowPeak --r1 ${BAMDIR}/female_donors_${chip}_${stim2}_merged.bam \
                        --r2 ${BAMDIR}/female_donors_${chip}_ctrl_merged.bam --n1 ${chip}_${stim2} --n2 ${chip}_ctrl --pe -o female_${chip}_${stim2}_vs_ctrl_manorm --rf bam --pf narrowpeak

		# run for male donor peaks
		echo "Running differential binding analysis for male donor ${chip} ${stim2} peaks"

		echo "manorm --p1 male_donors_${chip}_${stim2}.macs3_peaks_filtered.narrowPeak --p2 male_donors_${chip}_ctrl.macs3_peaks_filtered.narrowPeak --r1 ${BAMDIR}/male_donors_${chip}_${stim2}_merged.bam \
                        --r2 ${BAMDIR}/male_donors_${chip}_ctrl_merged.bam --n1 ${chip}_${stim2} --n2 ${chip}_ctrl --pe -o male_${chip}_${stim2}_vs_ctrl_manorm --rf bam --pf narrowpeak"

                manorm --p1 male_donors_${chip}_${stim2}.macs3_peaks_filtered.narrowPeak --p2 male_donors_${chip}_ctrl.macs3_peaks_filtered.narrowPeak --r1 ${BAMDIR}/male_donors_${chip}_${stim2}_merged.bam \
                        --r2 ${BAMDIR}/male_donors_${chip}_ctrl_merged.bam --n1 ${chip}_${stim2} --n2 ${chip}_ctrl --pe -o male_${chip}_${stim2}_vs_ctrl_manorm --rf bam --pf narrowpeak
	done
done
