#!/bin/bash
#SBATCH --partition=savio
#SBATCH --account=fc_rothfelslab
#SBATCH --qos=savio_normal
#SBATCH --mail-user=cmt2@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --time=00:30:00

cd /global/scratch/cmt2/underground_evo
echo loading modules
module load r/3.6.3
module load r-packages/default
module load r-spatial/2018-12-05-r35
module load imagemagick/7.0.8-29
echo finished loading modules
echo starting r runs
Rscript bayou/bayou_Rscript.R --i 1 --clim_var bio15 --run_num 4 --ngen 5000000 &
Rscript bayou/bayou_Rscript.R --i 1 --clim_var bio4 --run_num 4 --ngen 5000000 &
Rscript bayou/bayou_Rscript.R --i 2 --clim_var bio15 --run_num 4 --ngen 5000000 &
Rscript bayou/bayou_Rscript.R --i 2 --clim_var bio4 --run_num 4 --ngen 5000000 &
Rscript bayou/bayou_Rscript.R --i 3 --clim_var bio15 --run_num 4 --ngen 5000000 &
Rscript bayou/bayou_Rscript.R --i 3 --clim_var bio4 --run_num 4 --ngen 5000000 &
Rscript bayou/bayou_Rscript.R --i 4 --clim_var bio15 --run_num 4 --ngen 5000000 &
Rscript bayou/bayou_Rscript.R --i 4 --clim_var bio4 --run_num 4 --ngen 5000000 &
Rscript bayou/bayou_Rscript.R --i 5 --clim_var bio15 --run_num 4 --ngen 5000000 &
Rscript bayou/bayou_Rscript.R --i 5 --clim_var bio4 --run_num 4 --ngen 5000000 &
wait; 
