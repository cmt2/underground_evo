# make 1 for each climate variable 

# bio4

t1 <- read.csv("comparison/results/bio4_tree_1.csv", row.names = 1)
t2 <- read.csv("comparison/results/bio4_tree_2.csv", row.names = 1)
t3 <- read.csv("comparison/results/bio4_tree_3.csv", row.names = 1)
t4 <- read.csv("comparison/results/bio4_tree_4.csv", row.names = 1)
t5 <- read.csv("comparison/results/bio4_tree_5.csv", row.names = 1)

combined_bio4 <- dplyr::bind_rows(t1,t2,t3,t4,t5)
colnames(combined_bio4) <- gsub("X", "", colnames(combined_bio4))

combined_bio4 <- combined_bio4[ , colSums(is.na(combined_bio4)) < 2500]

bio4_melted <- reshape2::melt(combined_bio4)
colors <- RevGadgets:::.colFun(ncol(combined_bio4))
names(colors) <- colnames(combined_bio4)

pdf("comparison/figures/combined_bio4.pdf")
ggplot(data = bio4_melted, 
       aes(value, fill = variable, colour = variable)) +
  geom_density(alpha = 0.1) + 
  scale_color_manual(values = colors) +
  scale_fill_manual(values = colors) +
  ggtitle("Temperature Seasonality") +
  theme_few()
dev.off()

# bio15

t1 <- read.csv("comparison/results/bio15_tree_1.csv", row.names = 1)
t2 <- read.csv("comparison/results/bio15_tree_2.csv", row.names = 1)
t3 <- read.csv("comparison/results/bio15_tree_3.csv", row.names = 1)
t4 <- read.csv("comparison/results/bio15_tree_4.csv", row.names = 1)
t5 <- read.csv("comparison/results/bio15_tree_5.csv", row.names = 1)

combined_bio15 <- dplyr::bind_rows(t1,t2,t3,t4,t5)
colnames(combined_bio15) <- gsub("X", "", colnames(combined_bio15))

combined_bio15 <- combined_bio15[ , colSums(is.na(combined_bio15)) < 2500]

bio15_melted <- reshape2::melt(combined_bio15)
colors <- RevGadgets:::.colFun(ncol(combined_bio15))
names(colors) <- colnames(combined_bio15)

pdf("comparison/figures/combined_bio15.pdf")
ggplot(data = bio15_melted, 
       aes(value, fill = variable, colour = variable)) +
  geom_density(alpha = 0.1) + 
  scale_color_manual(values = colors) +
  scale_fill_manual(values = colors) +
  ggtitle("Precipitation Seasonality") +
  theme_few()
dev.off()