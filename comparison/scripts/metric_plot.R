setwd("~/Documents/underground_evo/")

### plot metric distributions 
source("comparison/scripts/plot_metric.R")
library(gridExtra)
library(ggpubr)

# character 1
p_1_4 <-  plot_metric(clim_var = "bio4", char = "1", trees = 1:10, split = "none")
p_1_15 <- plot_metric(clim_var = "bio15", char = "1", trees = 1:10, split = "none")

# character 2
p_2_4 <-  plot_metric(clim_var = "bio4", char = "2", trees = 1:10, split = "none")
p_2_15 <- plot_metric(clim_var = "bio15", char = "2", trees = 1:10, split = "none")

# character 3
p_3_4 <-  plot_metric(clim_var = "bio4", char = "3", trees = 1:10, split = "none")
p_3_15 <- plot_metric(clim_var = "bio15", char = "3", trees = 1:10, split = "none")

# combined 
p_c_4 <-  plot_metric(clim_var = "bio4", char = "combined", trees = 1:10, split = "none")
p_c_15 <- plot_metric(clim_var = "bio15", char = "combined", trees = 1:10, split = "none")


pdf("comparison/figures/metricsAll.pdf", width = 9, height = 12)
grid.arrange(p_1_4 + ggtitle("Temperature Seasonality") + ylab("Leaf") + rremove("xlab"), p_1_15 + ggtitle("Precipitation Seasonality") + ylab(" ") + rremove("xlab"),
             p_2_4 + ylab("Stem") + rremove("xlab"), p_2_15 + rremove("legend") + ylab(" ") + rremove("xlab"),
             p_3_4 + ylab("Root") + rremove("xlab"), p_3_15 + rremove("legend") + ylab(" ") + rremove("xlab"),
             p_c_4 + ylab("Combined"), p_c_15 + rremove("legend") + ylab(" "),
             ncol = 2, nrow = 4)
dev.off()
