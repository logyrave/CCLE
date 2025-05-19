setwd("~/Desktop/IRCM_2025/Exp/CCLE")
library(dplyr)
library(readxl)
library(gridExtra)
source("utils.R")

metaflux <- read.csv("../Processed_output/Metaflux_CCLE_final.csv")
scfea <- read.csv("../Processed_output/scFEA_CCLE_final.csv")
rw <- read.csv("../Processed_output/RW_CCLE_final.csv")


module_pathway_table <- read_excel(
  "~/Desktop/IRCM_2025/Metabo_prediction/BENCHMARK/scFEA/scFEA/supplementary data/Supplementary_Table_S1.xlsx", 
  sheet = "Module_info", col_types = c("text", 
                                       "skip", "skip", "skip", "skip", "skip", 
                                       "skip", "text"))

metabolic_data <- read_excel("NIHMS1033364-supplement-Supplementary_Tables_1__2__3__4.xlsx",
                             sheet = "1-clean data")

metadata <- read.csv("../Raw_output/metadata_CCLE.csv")

mesured_metabolite_list <- c(colnames(metabolic_data))

metaflux$Cluster. <- metadata$CellType[match(metaflux$Cluster., metadata$Cluster)]
scfea$Cluster <- metadata$CellType[match(scfea$Cluster, metadata$Cluster)]


