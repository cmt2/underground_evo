#plot paramo figure for tree one 

source("paramo/scripts/plot_simmap.R")
load("paramo/output/paramo_results1.RData")

data <- results[[3]]

states <- unique(unlist(lapply(data, 
                               function(i) unique(names(unlist(i$maps))))))
col_vec <- RevGadgets:::.colFun(length(states))
names(col_vec) <- states

pdf("~/Desktop/paramo_1.pdf", height = 20, width = 15)
plot_simmap(time_tree = data[[1]], 
            tree = data[[1]], 
            simmaps = data, 
            states = states,
            show.tip.label = TRUE,
            plot_pie = F,
            colors = col_vec)
legend(x = 0, y = 100, legend = names(col_vec), col = col_vec, pch = 20)
dev.off()
