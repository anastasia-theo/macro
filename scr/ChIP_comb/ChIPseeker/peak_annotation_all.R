# Load required libraries
library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(org.Hs.eg.db)
library(clusterProfiler)

# # Set directories
# egr1_folder <- "~/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/EGR1"
# egr2_folder <- "~/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/EGR2"
# output_folder <- "~/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_condition/annotated_chipseeker"
# 
# # Create output directory
# if (!dir.exists(output_folder)) {
#   dir.create(output_folder, showWarnings = FALSE)
# }
# 
# # Get narrowPeak files
# files_folder1 <- list.files(egr1_folder, pattern = "\\.xls$", full.names = TRUE)
# files_folder2 <- list.files(egr2_folder, pattern = "\\.xls$", full.names = TRUE)
# all_peak_files <- c(files_folder1, files_folder2)


# Set directories
base_dir <- "~/macro/raw_data/ChIP_comb/ChIP_comb_merged_per_donor"
output_folder <- file.path(base_dir, "annotated_chipseeker_EGR")
dir.create(output_folder, showWarnings = FALSE)

# Get all XLS files from subfolders
all_peak_files <- list.files(
  path = c(file.path(base_dir, "EGR2/manorm/IL4_ctrl"),
           file.path(base_dir, "EGR2/manorm/LPS_ctrl"),
           file.path(base_dir, "EGR2/manorm/LPS+IL4_ctrl"),
           file.path(base_dir, "EGR1/manorm/IL4_ctrl"),
           file.path(base_dir, "EGR1/manorm/LPS_ctrl"),
           file.path(base_dir, "EGR1/manorm/LPS+IL4_ctrl"),
           file.path(base_dir, "H3K27ac/manorm/IL4_ctrl"),
           file.path(base_dir, "H3K27ac/manorm/LPS_ctrl"),
          file.path(base_dir, "H3K27ac/manorm/LPS+IL4_ctrl")),
  pattern = "all_MAvalues\\.xls$",
  recursive = TRUE,  # This looks in subfolders
  full.names = TRUE
)

# file.path(base_dir, "EGR1/manorm/272_IL4_ctrl"),


# Function to annotate peaks
annotate_peaks <- function(peak_file) {
  # Read peaks
  peaks <- readPeakFile(peak_file)
  
  # Exclude non-autosomal chromosomes
  peaks <- peaks[grepl("^chr[0-9]+$", seqnames(peaks))]
  
  # Annotate peaks
  peak_anno <- annotatePeak(
    peaks,
    tssRegion = c(-3000, 3000),
    TxDb = TxDb.Hsapiens.UCSC.hg38.knownGene,
    annoDb = "org.Hs.eg.db",
    level = "gene",
    assignGenomicAnnotation = TRUE,
    # genomicAnnotationPriority = c("Promoter"),
    genomicAnnotationPriority = c("Promoter", "5UTR", "3UTR", "Exon", "Intron", "Downstream", "Intergenic"),
    verbose = TRUE
  )
  
  # Convert to data frame
  results <- as.data.frame(peak_anno)
  print(results)
  colnames(results)[colnames(results) == "seqnames"] <- "chr"
  
  # Select columns to keep
  #keep_cols <- c("chr", "start", "end", "width", "strand",
  #               "summit", "M_value", "A_value", "P_value", "Peak_Group",
  #              "annotation", "geneId", "distanceToTSS",
  #               "SYMBOL", "GENENAME")
  
  # Filter to available columns
  #results <- results[, intersect(keep_cols, colnames(results))]
  
  # Create output filename
  sample_name <- tools::file_path_sans_ext(basename(peak_file))
  output_file <- file.path(output_folder, paste0(sample_name, "_annotated.xls"))
  
  # Write results
  write.table(results, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE)
  
  return(results)
}

# Process all files
peak_annotations <- lapply(all_peak_files, annotate_peaks)

# Name the results
names(peak_annotations) <- basename(all_peak_files)

# Save complete results
saveRDS(peak_annotations, file.path(output_folder, "all_peak_annotations.rds"))

# Print completion message
message("Annotation completed successfully! Results saved in: ", output_folder)






