#!/bin/bash
#SBATCH --qos=debug    # Partition or queue name
#SBATCH --constraint=gpu    # Partition or queue name
#SBATCH --nodes=1                     # Number of nodes
#SBATCH --ntasks-per-node=1           # Number of tasks per node
#SBATCH --cpus-per-task=1             # Number of CPU cores per task
#SBATCH --gpus=1
#SBATCH --time=00:05:00                # Maximum runtime (D-HH:MM:SS)
#SBATCH --account=<Please Add project here>

echo "Hi There!! :)" > ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
