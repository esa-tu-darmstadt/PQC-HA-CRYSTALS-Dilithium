#!/bin/bash
#SBATCH -J tapasco_dilithium_compose_ultra96v2

#SBATCH -D /net/cirithungol/rs/thesis/dilithium/ref_master
#SBATCH -e /net/cirithungol/rs/thesis/slurm/logs/%x.%4j.err
#SBATCH -o /net/cirithungol/rs/thesis/slurm/logs/%x.%4j.out

#SBATCH --partition=Epyc

#SBATCH -n 1
#SBATCH -c 16
#SBATCH --mem-per-cpu=4096
#SBATCH -t 72:00:00

echo "Slurm Job ID: $SLURM_JOB_ID"

# $HOME needs to be set to a writable directory or Vivado will fail
# silently without throwing an error.
mkdir -p /net/cirithungol/rs
export HOME=/net/cirithungol/rs

# Using Vitis 2020.2:
source /opt/cad/xilinx/vitis/Vivado/2020.2/settings64.sh
source ./tapasco-setup.sh

# Design Space Exploration for minimum Area on Ultra96v2
# (50 MHz is the lowest possible frequency for DSE)
tapasco hls dilithium2_sign --skipEvaluation -p ultra96v2
tapasco compose [ dilithium2_sign x 1 ] @ 25 MHz -p ultra96v2
