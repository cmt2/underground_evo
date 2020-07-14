# make 1 for each climate variable 

# bio4

t1 <- read.csv("comparison/results/bio4_tree_1_collapsed.csv", row.names = 1)
t2 <- read.csv("comparison/results/bio4_tree_2_collapsed.csv", row.names = 1)
t3 <- read.csv("comparison/results/bio4_tree_3_collapsed.csv", row.names = 1)
t4 <- read.csv("comparison/results/bio4_tree_4_collapsed.csv", row.names = 1)
t5 <- read.csv("comparison/results/bio4_tree_5_collapsed.csv", row.names = 1)

combined_bio4 <- dplyr::bind_rows(t1,t2,t3,t4,t5)
colnames(combined_bio4) <- gsub("X", "", colnames(combined_bio4))

combined_bio4 <- combined_bio4[ , colSums(is.na(combined_bio4)) < 2500]

bio4_melted <- reshape2::melt(combined_bio4)
if (ncol(combined_bio4) < 13) {
  col_vec <- RevGadgets:::.colFun(ncol(combined_bio4))
} else if (ncol(combined_bio4) >= 13 & ncol(combined_bio4) < 37) {
  col_vec <- palette36.colors(ncol(combined_bio4))
} else if (ncol(combined_bio4) >= 37){
  col_vec <- colorRampPalette(RevGadgets:::.colFun(10))(ncol(combined_bio4))
}
names(col_vec) <- colnames(combined_bio4)

pdf("comparison/figures/combined_bio4_collapsed.pdf")
ggplot(data = bio4_melted, 
       aes(value, fill = variable, colour = variable)) +
  geom_density(alpha = 0.1) + 
  scale_color_manual(values = col_vec) +
  scale_fill_manual(values = col_vec) +
  ggtitle("Temperature Seasonality") +
  theme_few()
dev.off()

# bio15

t1 <- read.csv("comparison/results/bio15_tree_1_collapsed.csv", row.names = 1)
t2 <- read.csv("comparison/results/bio15_tree_2_collapsed.csv", row.names = 1)
t3 <- read.csv("comparison/results/bio15_tree_3_collapsed.csv", row.names = 1)
t4 <- read.csv("comparison/results/bio15_tree_4_collapsed.csv", row.names = 1)
t5 <- read.csv("comparison/results/bio15_tree_5_collapsed.csv", row.names = 1)

combined_bio15 <- dplyr::bind_rows(t1,t2,t3,t4,t5)
colnames(combined_bio15) <- gsub("X", "", colnames(combined_bio15))

combined_bio15 <- combined_bio15[ , colSums(is.na(combined_bio15)) < 2500]

bio15_melted <- reshape2::melt(combined_bio15)
if (ncol(combined_bio15) < 13) {
  col_vec <- RevGadgets:::.colFun(ncol(combined_bio15))
} else if (ncol(combined_bio15) >= 13 & ncol(combined_bio15) < 37) {
  col_vec <- palette36.colors(ncol(combined_bio15))
} else if (ncol(combined_bio15) >= 37){
  col_vec <- colorRampPalette(RevGadgets:::.colFun(10))(ncol(combined_bio15))
}
names(col_vec) <- colnames(combined_bio15)

pdf("comparison/figures/combined_bio15_collapsed.pdf")
ggplot(data = bio15_melted, 
       aes(value, fill = variable, colour = variable)) +
  geom_density(alpha = 0.1) + 
  scale_color_manual(values = col_vec) +
  scale_fill_manual(values = col_vec) +
  ggtitle("Precipitation Seasonality") +
  theme_few()
dev.off()
