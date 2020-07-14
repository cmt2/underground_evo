#plot paramo figure for tree one 

source("paramo/scripts/plot_simmap.R")
load("paramo/output/paramo_results5.RData")

data <- results[[3]]

states <- unique(unlist(lapply(data, 
                               function(i) unique(names(unlist(i$maps))))))
if (length(states) < 13) {
  col_vec <- RevGadgets:::.colFun(length(states))
} else if (length(states) >= 13 & length(states) < 37) {
  col_vec <- palette36.colors(length(states))
} else if (length(states) >= 37){
  col_vec <- colorRampPalette(RevGadgets:::.colFun(10))(length(states))
}
names(col_vec) <- states

pdf("paramo/figures/paramo_5.pdf", height = 30, width = 15)
plot_simmap(time_tree = data[[1]], 
            tree = data[[1]], 
            simmaps = data, 
            states = states,
            show.tip.label = TRUE,
            plot_pie = F,
            lwd = 2.5,
            label.cex = 0.5,
            colors = col_vec)
legend(x = 0, y = 200, legend = names(col_vec), col = col_vec, pch = 20)
dev.off()
