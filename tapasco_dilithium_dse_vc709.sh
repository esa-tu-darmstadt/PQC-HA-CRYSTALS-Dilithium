#!/bin/bash
#SBATCH -J tapasco_dilithium_dse

#SBATCH -D /net/cirithungol/rs/thesis/dilithium/ref_master
#SBATCH -e /net/cirithungol/rs/thesis/slurm/logs/%x.%4j.err
#SBATCH -o /net/cirithungol/rs/thesis/slurm/logs/%x.%4j.out

#SBATCH --partition=Epyc

#SBATCH -n 1
#SBATCH -c 16
#SBATCH --mem-per-cpu=4096
#SBATCH -t 168:00:00

echo "Slurm Job ID: $SLURM_JOB_ID"

# $HOME needs to be set to a writable directory or Vivado will fail
# silently without throwing an error.
mkdir -p /net/cirithungol/rs
export HOME=/net/cirithungol/rs

# Using Vitis 2020.2:
source /opt/cad/xilinx/vitis/Vivado/2020.2/settings64.sh
source ./tapasco-setup.sh

# Perform HLS
tapasco hls dilithium2_sign --skipEvaluation -p vc709
tapasco hls dilithium2_verify --skipEvaluation -p vc709

tapasco hls dilithium3_sign --skipEvaluation -p vc709
tapasco hls dilithium3_verify --skipEvaluation -p vc709

tapasco hls dilithium5_sign --skipEvaluation -p vc709
tapasco hls dilithium5_verify --skipEvaluation -p vc709

# Design Space Exploration for Max Frequency on vc709
tapasco explore [ dilithium2_sign x 1 ] @ 500 MHz in frequency -p vc709
tapasco explore [ dilithium3_sign x 1 ] @ 500 MHz in frequency -p vc709
tapasco explore [ dilithium5_sign x 1 ] @ 500 MHz in frequency -p vc709

tapasco explore [ dilithium2_verify x 1 ] @ 500 MHz in frequency -p vc709
tapasco explore [ dilithium3_verify x 1 ] @ 500 MHz in frequency -p vc709
tapasco explore [ dilithium5_verify x 1 ] @ 500 MHz in frequency -p vc709
