#!/bin/bash
#SBATCH -J GMM_sim
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH -t 12:00:00
#SBATCH --account=your-account-name  # (Optional) specify your SLURM account

# Load R module (adjust according to your cluster environment)
module load r

# Optional: set R_LIBS if required by your cluster
# mkdir -p ~/.local/R/$EBVERSIONR/
# export R_LIBS=~/.local/R/$EBVERSIONR/

Rscript --max-ppsize=500000 ./main.R $1 $2 $3 $4 $5 $6
