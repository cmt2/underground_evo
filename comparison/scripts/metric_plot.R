### plot metric distributions 
source("comparison/scripts/plot_metric.R")

# character 1
p_1_4 <-  plot_metric(clim_var = "bio4", char = "1")
p_1_15 <- plot_metric(clim_var = "bio15", char = "1")

# character 2
p_2_4 <-  plot_metric(clim_var = "bio4", char = "2")
p_2_15 <- plot_metric(clim_var = "bio15", char = "2")

# character 3
p_3_4 <-  plot_metric(clim_var = "bio4", char = "3")
p_3_15 <- plot_metric(clim_var = "bio15", char = "3")

# combined 
p_c_4 <-  plot_metric(clim_var = "bio4", char = "combined")
p_c_15 <- plot_metric(clim_var = "bio15", char = "combined")


pdf("comparison/figures/metrics.pdf", width = 9, height = 12)
grid.arrange(p_1_4 + ggtitle("Temperature Seasonality") + ylab("Leaf") + rremove("xlab"), p_1_15 + ggtitle("Precipitation Seasonality") + ylab(" ") + rremove("xlab"),
             p_2_4 + ylab("Stem") + rremove("xlab"), p_2_15 + rremove("legend") + ylab(" ") + rremove("xlab"),
             p_3_4 + ylab("Root") + rremove("xlab"), p_3_15 + rremove("legend") + ylab(" ") + rremove("xlab"),
             p_c_4 + ylab("Combined"), p_c_15 + rremove("legend") + ylab(" "),
             ncol = 2, nrow = 4)
dev.off()
