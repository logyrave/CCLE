setwd("~/Desktop/IRCM_2025/Exp/CCLE")
data <- read.csv("../OmicsExpressionProteinCodingGenesTPMLogp1BatchCorrected.csv", 
                                                                    row.names=1)

id_list <- read.table("id_list.txt", quote="\"", comment.char="")

data <- data[rownames(data) %in% id_list$V1, ]

write.csv(data,"RNA_seq_filtered.csv")

Model <- read.csv("../Model.csv")


name_mapping <- setNames(Model$StrippedCellLineName, Model$ModelID)
rownames(data) <- name_mapping[rownames(data)]
head(rownames(data))
colnames(data) <- sub("\\..*", "", colnames(data))

data[data < 0] <- 0
any(data < 0)

write.csv(data,"RNA_seq_filtered.csv")
