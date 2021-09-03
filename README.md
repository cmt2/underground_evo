# underground_evo

## Scripts used in modeling underground evolution and climatic niche evolution in Liliales.

These scripts form a pipeline that relies on the R package [bayou](https://github.com/uyedaj/bayou) and the [PARAMO pipeline](https://github.com/phenoscape/scate-shortcourse). 
The required inputs are:
- Dated trees from the posterior distribution of trees 
- Coded morphological data for all species and accompanying dependency matrix (depend_mat.csv in these data)
- Climatic estimates for all species

The schematic below illustrates the overall organization of the scripts into the pipeline. Scripts in dashed boxes are sourced by other scripts (not directly used by user).

![pipeline schematic](https://github.com/cmt2/underground_evo/blob/master/schematic.png?raw=true)
