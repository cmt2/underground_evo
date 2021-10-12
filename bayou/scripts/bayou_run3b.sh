#!/bin/bash
#SBATCH --partition=savio
#SBATCH --account=fc_rothfelslab
#SBATCH --qos=savio_normal
#SBATCH --mail-user=cmt2@berkeley.edu
#SBATCH --mail-type=ALL
#SBATCH --time=72:00:00

cd /global/scratch/cmt2/underground_evo
echo loading modules
module load r/3.6.3
module load r-packages/default
module load r-spatial/2020-11-30-r36
module load imagemagick/7.0.8-29
echo finished loading modules
echo starting r runs
Rscript bayou/scripts/bayou_Rscript.R --i 6  --clim_var bio15 --run_num 3 --ngen 3000000 &
Rscript bayou/scripts/bayou_Rscript.R --i 6  --clim_var bio4  --run_num 3 --ngen 3000000 &
Rscript bayou/scripts/bayou_Rscript.R --i 7  --clim_var bio15 --run_num 3 --ngen 3000000 &
Rscript bayou/scripts/bayou_Rscript.R --i 7  --clim_var bio4  --run_num 3 --ngen 3000000 &
Rscript bayou/scripts/bayou_Rscript.R --i 8  --clim_var bio15 --run_num 3 --ngen 3000000 &
Rscript bayou/scripts/bayou_Rscript.R --i 8  --clim_var bio4  --run_num 3 --ngen 3000000 &
Rscript bayou/scripts/bayou_Rscript.R --i 9  --clim_var bio15 --run_num 3 --ngen 3000000 &
Rscript bayou/scripts/bayou_Rscript.R --i 9  --clim_var bio4  --run_num 3 --ngen 3000000 &
Rscript bayou/scripts/bayou_Rscript.R --i 10 --clim_var bio15 --run_num 3 --ngen 3000000 &
Rscript bayou/scripts/bayou_Rscript.R --i 10 --clim_var bio4  --run_num 3 --ngen 3000000 &
wait; 