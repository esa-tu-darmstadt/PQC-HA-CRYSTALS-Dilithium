#!/bin/bash
#SBATCH -J tapasco_dilithium_hls

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

ARCHITECTURES="vc709,AU280"

# Perform HLS but skip evaluation because I don't want to do design space
# exploration (yet) and it takes ages to route this with 1 GHz..
#
# Comment the Keypair Generation because it doesn't make any sense without a
# good source of randomness:
#tapasco hls dilithium2_gen --skipEvaluation -p $ARCHITECTURES

tapasco hls dilithium2_sign --skipEvaluation -p $ARCHITECTURES
tapasco hls dilithium2_verify --skipEvaluation -p $ARCHITECTURES

tapasco hls dilithium3_sign --skipEvaluation -p $ARCHITECTURES
tapasco hls dilithium3_verify --skipEvaluation -p $ARCHITECTURES

tapasco hls dilithium5_sign --skipEvaluation -p $ARCHITECTURES
tapasco hls dilithium5_verify --skipEvaluation -p $ARCHITECTURES

# Signing and Verifying for each security level in one design
tapasco compose [ dilithium2_sign x 1, dilithium2_verify x 1 ] @ 100 MHz -p $ARCHITECTURES
tapasco compose [ dilithium3_sign x 1, dilithium3_verify x 1 ] @ 100 MHz -p $ARCHITECTURES
tapasco compose [ dilithium5_sign x 1, dilithium5_verify x 1 ] @ 100 MHz -p $ARCHITECTURES

# All security levels in one design
tapasco compose [ dilithium2_sign x 1, dilithium3_sign x 1, dilithium5_sign x 1, dilithium2_verify x 1, dilithium3_verify x 1, dilithium5_verify x 1 ] @ 100 MHz -p $ARCHITECTURES
