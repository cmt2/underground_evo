# execute bayou fun with scriptR

# direct to library for packages
.libPaths(new = "/global/home/users/cmt2/R/x86_64-pc-linux-gnu-library/3.6")
# get the arguments
args <- commandArgs(trailingOnly = TRUE)
#args = c("--i", 1, "--clim_var", "bio4", "--run_num", 2, "--ngen", "5000")


.i <- args[which(args == "--i") + 1]
.clim_var <- args[which(args == "--clim_var") + 1]
.rum_num <- args[which(args == "--run_num") + 1]
.ngen <- args[which(args == "--ngen") + 1]

# load libraries and source function
source("bayou/run_bayou.R")
library(bayou)

run_bayou(i = as.integer(.i), 
          clim_var = .clim_var, 
          run_num = .rum_num,
          ngen = as.integer(.ngen))

