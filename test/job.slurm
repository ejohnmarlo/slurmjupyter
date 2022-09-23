#!/bin/bash

#SBATCH --output=notMNIST.out
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2

conda activate cuda

srun nvidia-smi
srun sleep 60
