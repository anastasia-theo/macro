# Load required libraries
library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(org.Hs.eg.db)
library(clusterProfiler)

# Set directories
egr1_folder <- "~/macro/raw_data/ChIP_comb/new_manorm_merged_sexes/merged_all_sex/EGR1"
egr2_folder <- "~/macro/raw_data/ChIP_comb/new_manorm_merged_sexes/merged_all_sex/EGR2"
output_folder <- "~/macro/raw_data/ChIP_comb/new_manorm_merged_sexes/merged_all_sex/annotated_chipseeker"

# Create output directory
if (!dir.exists(output_folder)) {
  dir.create(output_folder, showWarnings = FALSE)
}

# Get narrowPeak files
files_folder1 <- list.files(egr1_folder, pattern = "\\.narrowPeak$", full.names = TRUE)
files_folder2 <- list.files(egr2_folder, pattern = "\\.narrowPeak$", full.names = TRUE)
all_peak_files <- c(files_folder1, files_folder2)

# Function to annotate peaks
annotate_peaks <- function(peak_file) {
  # Read peaks
  peaks <- readPeakFile(peak_file)
  
  # Annotate peaks
  peak_anno <- annotatePeak(
    peaks,
    tssRegion = c(-3000, 3000),
    TxDb = TxDb.Hsapiens.UCSC.hg38.knownGene,
    annoDb = "org.Hs.eg.db",
    level = "gene",
    assignGenomicAnnotation = TRUE,
    genomicAnnotationPriority = c("Promoter", "5UTR", "3UTR", "Exon", "Intron", "Downstream", "Intergenic"),
    verbose = TRUE
  )
  
  # Convert to data frame
  results <- as.data.frame(peak_anno)
  head(results)
  
  # Select columns to keep
  keep_cols <- c("seqnames", "start", "end", "width", "strand",
                 "annotation", "geneId", "distanceToTSS",
                 "SYMBOL", "GENENAME")
  
  # Filter to available columns
  results <- results[, intersect(keep_cols, colnames(results))]
  
  # Create output filename
  sample_name <- tools::file_path_sans_ext(basename(peak_file))
  output_file <- file.path(output_folder, paste0(sample_name, "_annotated.tsv"))
  
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






