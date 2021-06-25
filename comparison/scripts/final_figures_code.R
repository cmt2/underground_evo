# plot of stochastic maps from bayou and paramo to illustrate methods
source("paramo/scripts/plot_simmap.R")
source("comparison/scripts/subset_chainOU.R")
# paramo 
load("~/Documents/underground_evo/paramo/output/paramo_results5.RData")
data <- results[[3]]

for (map in 1:length(data)) {
  for (branch in 1:length(data[[map]]$maps)) {
    n <- names(data[[map]]$maps[[branch]]) 
    #n <- dplyr::recode(n, "4" = "0", "5" = "1", "6" = "2", "7" = "3")
    #n <- dplyr::recode(n, "2" = "0", "3" = "1")
    n <- dplyr::recode(n, "014" = "010","054" = "010","254" = "010","256" = "012",
                       "257" = "013","255" = "011","245" = "001","244" = "000",
                       "264" = "020","344" = "100","354" = "110","214" = "010",
                       "246" = "002","050" = "010","250" = "010","364" = "120",
                       "355" = "111","274" = "030","210" = "010","010" = "010",
                       "356" = "112","346" = "102","345" = "101","266" = "022",
                       "240" = "000","340" = "100","044" = "000","314" = "110",
                       "216" = "012","217" = "013","215" = "011") 
    names(data[[map]]$maps[[branch]]) <- n
  }
}
states <- unique(unlist(lapply(data, 
                               function(i) unique(names(unlist(i$maps))))))
#col_vec <- c("#fed98e","#993404", "white", "#fe9929")
#names(col_vec) <- states
colors <- c("#14d2dc", "#005ac8", "#fa7850", "#aa0a3c", "#0ab45a", "#006e82", "#fa78fa", "#8214a0", "#fae6be", "#00a0fa")
names(colors) <- c("000", "001", "002", "010", "011", "012", "020", "030", "100", "110")

col_vec <- vector("character", length = length(states))
for (c in 1:length(states)) {
  if (states[c] %in% names(colors)) {
    col_vec[c] <- colors[which(names(colors) == states[c])]
  } else {
    col_vec[c] <- "grey"
  }
  names(col_vec)[c] <- states[c]
}


pdf("paramo/figures/combined.pdf", height = 10, width = 5)
plot_simmap(time_tree = data[[1]], 
            tree = data[[1]], 
            simmaps = data, 
            states = states,
            show.tip.label = F,
            plot_pie = F,
            lwd = 2.5,
            label.cex = 0.5,
            colors = col_vec)
#legend(x = -4, y = 5, legend = c("none","elongate","rotund"), col = c("#fed98e","#fe9929","#993404"), pch = 20, yjust = 0, bty = 'n', cex = 1.5, pt.cex = 3)
legend(x = -4, y = 5, legend = names(col_vec[c(6,5,10,1,4,2,7,13,8,9)]), col = col_vec[c(6,5,10,1,4,2,7,13,8,9)], pch = 20, yjust = 0, bty = 'n', cex = 1, pt.cex = 3)
dev.off()

load("~/Documents/underground_evo/bayou/output/processed_output/bio15_tree_5_r001.RData")
chainOU_bio15 <- chainOU


pdf("bayou/figures/bayou15.pdf", height = 10, width = 5)
plotBranchHeatMap(tree = attributes(chainOU_bio4)$tree,
                  chain = chainOU_bio15,
                  variable = "theta",
                  burnin = 0.1,
                  nn = 20,
                  #pal = colorRampPalette(viridis::inferno(n = 20, direction = -1)),
                  pal = colorRampPalette(RColorBrewer::brewer.pal(9, "YlGnBu")),
                  show.tip.label = FALSE,
                  legend_settings = list(plot = T, x = 20, height = 150, width = 10, cex.lab = 1.5) )
dev.off()
