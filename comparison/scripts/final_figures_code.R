# plot of stochastic maps from bayou and paramo to illustrate methods
source("paramo/scripts/plot_simmap.R")
source("comparison/scripts/subset_chainOU.R")
# paramo 
load("~/Documents/underground_evo/paramo/output/paramo_results5.RData")

#### LEAF #### 
data <- results[[2]][[1]]

for (map in 1:length(data)) {
  for (branch in 1:length(data[[map]]$maps)) {
    n <- names(data[[map]]$maps[[branch]]) 
    n <- dplyr::recode(n, "2" = "0", "3" = "1")
    names(data[[map]]$maps[[branch]]) <- n
  }
}
states <- unique(unlist(lapply(data, 
                               function(i) unique(names(unlist(i$maps))))))
col_vec <- c("#addd8e","#31a354")
names(col_vec) <- states

pdf("~/Desktop/char1.pdf", height = 10, width = 5)
plot_simmap(time_tree = data[[1]], 
            tree = data[[1]], 
            simmaps = data, 
            states = states,
            show.tip.label = F,
            plot_pie = F,
            lwd = 2.5,
            label.cex = 0.5,
            colors = col_vec)
legend(x = -4, y = 5, legend = c("0: none","1: bulb"), col = c("#addd8e","#31a354"), pch = 20, yjust = 0, bty = 'n', cex = 1.5, pt.cex = 3)
dev.off()

#### STEM #### 
data <- results[[2]][[2]]

for (map in 1:length(data)) {
  for (branch in 1:length(data[[map]]$maps)) {
    n <- names(data[[map]]$maps[[branch]]) 
    n <- dplyr::recode(n, "4" = "0", "5" = "1", "6" = "2", "7" = "3")
    names(data[[map]]$maps[[branch]]) <- n
  }
}
states <- unique(unlist(lapply(data, 
                               function(i) unique(names(unlist(i$maps))))))
col_vec <- c("#41b6c4","#a1dab4","#2c7fb8","#253494")
names(col_vec) <- states

pdf("~/Desktop/char2.pdf", height = 10, width = 5)
plot_simmap(time_tree = data[[1]], 
            tree = data[[1]], 
            simmaps = data, 
            states = states,
            show.tip.label = F,
            plot_pie = F,
            lwd = 2.5,
            label.cex = 0.5,
            colors = col_vec)
legend(x = -4, y = 5, legend = c("0: none","1: rhizome", "2: corm", "3: both"), col = c("#a1dab4","#41b6c4","#2c7fb8","#253494"), pch = 20, yjust = 0, bty = 'n', cex = 1.5, pt.cex = 3)
dev.off()


#### root #### 
data <- results[[2]][[3]]

for (map in 1:length(data)) {
  for (branch in 1:length(data[[map]]$maps)) {
    n <- names(data[[map]]$maps[[branch]]) 
    n <- dplyr::recode(n, "4" = "0", "5" = "1", "6" = "2", "7" = "3")
    names(data[[map]]$maps[[branch]]) <- n
  }
}
states <- unique(unlist(lapply(data, 
                               function(i) unique(names(unlist(i$maps))))))
col_vec <- c("#fed98e","#993404", "white", "#fe9929")
names(col_vec) <- states

pdf("~/Desktop/char3.pdf", height = 10, width = 5)
plot_simmap(time_tree = data[[1]], 
            tree = data[[1]], 
            simmaps = data, 
            states = states,
            show.tip.label = F,
            plot_pie = F,
            lwd = 2.5,
            label.cex = 0.5,
            colors = col_vec)
legend(x = -4, y = 5, legend = c("0: none","1: elongate","2: rotund"), col = c("#fed98e","#fe9929","#993404"), pch = 20, yjust = 0, bty = 'n', cex = 1.5, pt.cex = 3)
dev.off()

#### COMBINED #### 
data <- results[[3]]

for (map in 1:length(data)) {
  for (branch in 1:length(data[[map]]$maps)) {
    n <- names(data[[map]]$maps[[branch]]) 
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

# make a hacky legend
legend_text <- names(col_vec[c(6,5,10,1,4,2,7,13,8,9)])
legend_matrix <- matrix(c("A","B","C",unlist(unlist(strsplit(legend_text, split = "")))), ncol = 3, byrow =T)
legend_matrix <- t(legend_matrix)
legend_matrix_one <- legend_matrix[1,]
legend_matrix[1,] <- paste0("", legend_matrix_one)
legend <- c(t(legend_matrix))


pdf("~/Desktop/combined.pdf", height = 10, width = 5)
plot_simmap(time_tree = data[[1]], 
            tree = data[[1]], 
            simmaps = data, 
            states = states,
            show.tip.label = F,
            plot_pie = F,
            lwd = 2.5,
            label.cex = 0.5,
            colors = col_vec)
legend(x = -7,
       y = -30,
       legend = legend,
       col = c("white", col_vec[c(6,5,10,1,4,2,7,13,8,9)], 
               rep("white", 22)),
       ncol = 3,
       text.width = 0.001,
       pch = 20,
       yjust = 0,
       bty = 'n',
       cex = 1, 
       pt.cex = 3
       )

dev.off()


#### BAYOU bio 15 #### 
library(bayou)
load("~/Documents/underground_evo/bayou/output/processed_output/bio15_tree_5_r001.RData")
chainOU_bio15 <- chainOU


pdf("~/Desktop/bayou15.pdf", height = 10, width = 5)
plotBranchHeatMap(tree = attributes(chainOU_bio15)$tree,
                  chain = chainOU_bio15,
                  variable = "theta",
                  burnin = 0.1,
                  nn = 20,
                  #pal = colorRampPalette(viridis::inferno(n = 20, direction = -1)),
                  pal = colorRampPalette(RColorBrewer::brewer.pal(9, "YlGnBu")),
                  show.tip.label = FALSE,
                  legend_settings = list(plot = T, x = 20, height = 150, width = 10, cex.lab = 1.5) )
dev.off()

#### BAYOU bio 4 #### 
load("~/Documents/underground_evo/bayou/output/processed_output/bio4_tree_5_r001.RData")
chainOU_bio4 <- chainOU



pdf("~/Desktop/bayou4.pdf", height = 10, width = 5)
plotBranchHeatMap(tree = attributes(chainOU_bio4)$tree,
                  chain = chainOU_bio4,
                  variable = "theta",
                  burnin = 0.1,
                  nn = 20,
                  pal = colorRampPalette(viridis::inferno(n = 20, direction = -1)),
                  show.tip.label = FALSE,
                  legend_settings = list(plot = T, x = 20, height = 150, width = 10, cex.lab = 1.5) )
dev.off()

