#Load all the necessary libraries

library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
library(org.Hs.eg.db)
org <- org.Hs.eg.db

# library(clusterProfiler)
# library(stringr)
# library(readr)
# library(dplyr)
# library(ggplot2)

setwd("/trinity/home/atheodosiadou/macro/raw_data/ChIP_comb")
files_path <- 









#MINE

#Load all the necessary libraries

# library(ChIPseeker)
# library(TxDb.Hsapiens.UCSC.hg38.knownGene)
# txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
# library(org.Hs.eg.db)
# org <- org.Hs.eg.db
# library(clusterProfiler)

# setwd("~/macro/raw_data/ChIP_comb")
# egr1_folder <- "~/macro/raw_data/ChIP_comb/EGR1/narrowPeak/"
# egr2_folder <- "~/macro/raw_data/ChIP_comb/EGR2/narrowPeak/"

# files_folder1 <- list.files(egr1_folder, pattern= "\\.narrowPeak$", full.names = TRUE)
# files_folder2 <- list.files(egr2_folder, pattern= "\\.narrowPeak$", full.names = TRUE)

# all_peak_files <- c(files_folder1,files_folder2)

# peak_annotations <- lapply(all_peak_files, function(file) {
#   peaks <- readPeakfile(file)
#   annotatePeak(
#     peaks,
#     tssRegion = c(-3000,3000),
#     TxDb = txdb,
#     annoDb = org,
#     level = "gene",
#     assignGenomi
#   )
# })

#Load all the necessary libraries

# library(ChIPseeker)
# library(TxDb.Hsapiens.UCSC.hg38.knownGene)
# txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
# library(org.Hs.eg.db)
# org <- "org.Hs.eg.db"
# library(clusterProfiler)

# setwd("~/macro/raw_data/ChIP_comb")
# egr1_folder <- "~/macro/raw_data/ChIP_comb/new_manorm_merged_sexes/merged_all_sex/EGR1"
# egr2_folder <- "~/macro/raw_data/ChIP_comb/new_manorm_merged_sexes/merged_all_sex/EGR2"
# output_folder <- "~/macro/raw_data/ChIP_comb/new_manorm_merged_sexes/merged_all_sex/annotated_chipseeker"

# dir.create(output_folder,showWarnings = FALSE)


# files_folder1 <- list.files(egr1_folder, full.names = TRUE)
# print(files_folder1)
# files_folder2 <- list.files(egr2_folder, full.names = TRUE)

# all_peak_files <- c(files_folder1,files_folder2)

# #process_peak_file <- function(file) {

# peak_annotations <- lapply(all_peak_files, function(file) {
#   peaks <- readPeakFile(file)
#   peak_anno <- annotatePeak(
#     peaks,
#     tssRegion = c(-3000,3000),
#     TxDb = txdb,
#     annoDb = org,
#     level = "gene",
#     assignGenomicAnnotation = TRUE,
#     genomicAnnotationPriority = c("Promoter", "5' UTR", "3' UTR", "Exon", "Intron", "Downstream", "Intergenic"),
#     verbose = TRUE
#   )

#   # Extract the nearest TSS information
# nearest_tss <- as.data.frame(peak_anno)$distanceToTSS
# gene_ids <- as.data.frame(peak_anno)$geneId

# results <- as.data.frame(peak_anno)
# nearest_tss_info <- results[, c("seqnames", "start", "end", "geneId", "distanceToTSS", "annotation")]
# head(nearest_tss_info)
# })








# =====================================

library(ChIPseeker)
library(stringr)
library(readr)
library(dplyr)
library(ggplot2)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
library(clusterProfiler)

setwd("~/data/ChIP_comb/trimmed_reads/mapped_reads_2/filtered_reads/merged_BAM/macs3_peaks_q_0.01")

peakfiles <- list.files(".", pattern = "narrowPeak")

for (i in peakfiles){
  nam <- str_split_i(i, ".macs3", 1)
  assign(nam, readPeakFile(i))
}

# load H3K27ac peaks too
hist <- "~/data/ChIP_comb/trimmed_reads/mapped_reads_2/filtered_reads/H3K27ac_ChIP/merged_BAM/macs3_broad_peaks_q_0.01_bc_0.1"

hist_peakfiles <- list.files(hist, pattern = "broadPeak")

for (i in hist_peakfiles){
  nam <- str_split_i(i, ".macs3", 1)
  assign(nam, readPeakFile(paste0(hist, "/", i)))
}

# all peaks in a list
peak_list <- mget(grep("EGR|H3K27", ls(), value=T))
# annotate peaks with ChIPseeker and TXDB
peakAnno <- lapply(peak_list, function(x) { annotatePeak(x, tssRegion=c(-2000, 2000),
                         TxDb=txdb, annoDb="org.Hs.eg.db")})

                         plotAnnoBar(peakAnno)

# Also run for the different overlapping peaks between EGR1 and EGR2
peakfiles <- list.files("EGR1_EGR2_LPS+IL4_intersect", pattern = "bed")

for (i in peakfiles){
  nam <- gsub(".bed", "", i)
  assign(nam, readPeakFile(paste0("EGR1_EGR2_LPS+IL4_intersect/", i)))
}

ovl <- mget(grep("overlap", ls(), value=T))

ovlAnno <- lapply(ovl, function(x) { annotatePeak(x, tssRegion=c(-2000, 2000),
                                                         TxDb=txdb, annoDb="org.Hs.eg.db")})

plotAnnoBar(ovlAnno)

# Functional enrichment of genes found in proximity or within peak sites

peak_genes <- lapply(peak_list, function(x) { seq2gene(x,
                                tssRegion = c(-2000, 2000), flankDistance = 10000, TxDb=txdb)})
# reactomePA pathways
GO <- lapply(peak_genes, enrichGO, 'org.Hs.eg.db', ont="BP", pvalueCutoff=0.01)