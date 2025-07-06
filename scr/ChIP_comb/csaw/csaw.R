library(csaw)
library(edgeR)
library(GenomicRanges)


# Define BAM files and sample info
# Example with 2 replicates per group
bam.files <- c(
  "/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_sex/EGR2/female_donors_EGR2_IL4_merged.bam", 
  "/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_sex/EGR2/male_donors_EGR2_IL4_merged.bam", 
  "/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_sex/EGR2/female_donors_EGR2_ctrl_merged.bam", 
  "/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_sex/EGR2/male_donors_EGR2_ctrl_merged.bam"
)
sample.info <- data.frame(
  Sample = c("female_donors_EGR2_IL4_merged", "male_donors_EGR2_IL4_merged", "female_donors_EGR2_ctrl_merged", "male_donors_EGR2_ctrl_merged"),
  Condition = c("IL4", "IL4", "ctrl", "ctrl")
)

win.counts <- windowCounts(bam.files, width=10000, spacing=1000)
y <- asDGEList(win.counts)
y$samples$group <- sample.info$Condition
y <- calcNormFactors(y)

# Filter low-abundance windows
keep <- filterByExpr(y, group=y$samples$group)
y <- y[keep,]

# Design matrix
design <- model.matrix(~group, data=y$samples)

# Estimate dispersion and fit model
y <- estimateDisp(y, design)
fit <- glmQLFit(y, design)
res <- glmQLFTest(fit, coef=2)

# Get significant windows
topTags(res)

# Get the results as a data.frame
# res_df <- as.data.frame(topTags(res, n=Inf))
res_df <- as.data.frame(res, n=Inf)

print(colnames(res_df))  # Should include logFC

# Extract genomic coordinates from win.counts
coords <- as.data.frame(rowRanges(win.counts))[rownames(res_df), c("seqnames", "start", "end")]

# Combine coordinates with results (remove window number column if present)
res_df <- cbind(coords, res_df)
print(colnames(res_df))  # Should include logFC


# FDR < 0.05 and logFC > 0 (biased to IL4)
il4_biased <- res_df[res_df$logFC > 1, ]
ctrl_biased <- res_df[res_df$logFC < -1, ]
unbiased <- res_df[res_df$logFC >= -1 & res_df$logFC <= 1, ]

# Save only IL4-biased peaks
write.table(il4_biased, file="/trinity/home/atheodosiadou/macro/results/csaw/csaw_EGR2_IL4_vs_ctrl_IL4_biased.txt", sep="\t", quote=FALSE, row.names=FALSE)
write.table(ctrl_biased, file="/trinity/home/atheodosiadou/macro/results/csaw/csaw_EGR2_IL4_vs_ctrl_ctrl_biased.txt", sep="\t", quote=FALSE, row.names=FALSE)
write.table(unbiased, file="/trinity/home/atheodosiadou/macro/results/csaw/csaw_EGR2_IL4_vs_ctrl_unbiased.txt", sep="\t", quote=FALSE, row.names=FALSE)

# Save to file
write.table(res_df, file="/trinity/home/atheodosiadou/macro/results/csaw/csaw_EGR2_IL4_vs_ctrl_results.txt", sep="\t", quote=FALSE, row.names=FALSE)
# # Save results
# write.table(topTags(res, n=Inf), file="/trinity/home/atheodosiadou/macro/results/csaw/csaw_EGR2_IL4_vs_ctrl_results.txt", sep="\t", quote=FALSE)
