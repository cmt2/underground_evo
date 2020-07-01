#!/bin/bash
#SBATCH --partition=savio
#SBATCH --account=fc_rothfelslab
#SBATCH --qos=savio_normal
#SBATCH --mail-user=cmt2@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --time=72:00:00

cd /global/scratch/cmt2/underground_evo

module load r/3.6.3
module load r-packages/default
module load r-packages/r-spatial/2018-12-05-r35
module load imagemagick/7.0.8-29

Rscript bayou/run_bayou.R --i 1 --clim_var "bio15" --run_num 1 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 1 --clim_var "bio15" --run_num 2 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 1 --clim_var "bio4" --run_num 1 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 1 --clim_var "bio4" --run_num 2 --ngen 10000000 &
 
Rscript bayou/run_bayou.R --i 2 --clim_var "bio15" --run_num 1 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 2 --clim_var "bio15" --run_num 2 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 2 --clim_var "bio4" --run_num 1 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 2 --clim_var "bio4" --run_num 2 --ngen 10000000 &
 
Rscript bayou/run_bayou.R --i 3 --clim_var "bio15" --run_num 1 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 3 --clim_var "bio15" --run_num 2 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 3 --clim_var "bio4" --run_num 1 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 3 --clim_var "bio4" --run_num 2 --ngen 10000000 &
 
Rscript bayou/run_bayou.R --i 4 --clim_var "bio15" --run_num 1 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 4 --clim_var "bio15" --run_num 2 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 4 --clim_var "bio4" --run_num 1 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 4 --clim_var "bio4" --run_num 2 --ngen 10000000 &
 
Rscript bayou/run_bayou.R --i 5 --clim_var "bio15" --run_num 1 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 5 --clim_var "bio15" --run_num 2 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 5 --clim_var "bio4" --run_num 1 --ngen 10000000 &
Rscript bayou/run_bayou.R --i 5 --clim_var "bio4" --run_num 2 --ngen 10000000;
wait; 
