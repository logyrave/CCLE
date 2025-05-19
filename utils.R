setwd("~/Desktop/IRCM_2025/Exp/CCLE")
library(pheatmap)
library(Rtsne)
library(ggplot2)
library(corrplot)
library(dplyr)
library(tidyr)

adjust_column <- function(metaflux, scfea, rw) {
  scfea <- scfea[order(scfea$Cluster), ]
  rw <- rw[order(rw$Cluster), ]
  metaflux <- metaflux[order(metaflux$CellType), ]
  rw <- rw[rw$Cluster != 10, ]
  scfea <- scfea[scfea$Cluster != 10, ]
  rw$Cluster <- rw$Cluster + 1
  scfea$Cluster <- scfea$Cluster + 1
  metaflux <- subset(metaflux, select = -CellType)
  names(metaflux)[names(metaflux) == 'Cluster.'] <- 'Cluster'
  to_return <- list(metaflux,scfea,rw)
  return(to_return)
}

group_module <- function(df, module_association_list) {
  cluster_long <- df %>%
    pivot_longer(-Cluster, names_to = "Module_id", values_to = "value")
  cluster_annotated <- cluster_long %>%
    inner_join(module_pathway_table, by = c("Module_id" = "...1"))
  pathway_summary <- cluster_annotated %>%
    mutate(abs_value = abs(value)) %>%
    group_by(c-Cluster, Pathway) %>%
    summarise(mean_abs_value = mean(abs_value, na.rm = TRUE), .groups = "drop")
  pathway_wide <- pathway_summary %>%
    pivot_wider(names_from = Pathway, values_from = mean_abs_value)
  return(pathway_wide)
}



normalize_by_module <- function(df) {
  numeric_data <- df[, !(colnames(df) %in% "cluster")]
  keep_cols <- apply(numeric_data, 2, function(x) all(is.finite(x)))
  numeric_data <- numeric_data[, keep_cols, drop = FALSE]
  centered <- sweep(numeric_data, 2, colMeans(numeric_data), "-")
  
  df_norm <- data.frame(cluster = df$cluster, centered)
  return(df_norm)
}

make_long_df <- function(df, condition_name, method_name) {
  df %>%
    pivot_longer(-cluster, names_to = "Pathway", values_to = "Value") %>%
    mutate(
      Condition = condition_name,
      Method = method_name,
      Cluster = as.factor(cluster)
    )
}










