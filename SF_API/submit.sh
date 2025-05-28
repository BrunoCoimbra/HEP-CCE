#!/bin/bash
#SBATCH --qos=debug    # Partition or queue name
#SBATCH --constraint=gpu    # Partition or queue name
#SBATCH --nodes=1                     # Number of nodes
#SBATCH --ntasks-per-node=1           # Number of tasks per node
#SBATCH --cpus-per-task=1             # Number of CPU cores per task
#SBATCH --gpus=1
#SBATCH --time=0:10:00                # Maximum runtime (D-HH:MM:SS)
#SBATCH --account=<Please add the project id>

echo "===> 1 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export TWOBYTWO_SIM=/global/homes/o/okilic/Projects/HEP-CCE-PAW/2x2_sim_worked
echo "===> 2 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
cd $TWOBYTWO_SIM
echo "===> 3 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out

export ARCUBE_OUTDIR_BASE=$SCRATCH/2x2tut_out
echo "===> 4 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export ARCUBE_LOGDIR_BASE=$SCRATCH/2x2tut_log
echo "===> 5 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
mkdir -p $ARCUBE_OUTDIR_BASE $ARCUBE_LOGDIR_BASE
echo "===> 6 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out

cd $TWOBYTWO_SIM/run-genie
echo "===> 7 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out

export ARCUBE_RUNTIME=SHIFTER
echo "===> 8 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export ARCUBE_CONTAINER=mjkramer/sim2x2:genie_edep.3_04_00.20230912
echo "===> 9 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export ARCUBE_DET_LOCATION=MiniRun5-Nu
echo "===> 10 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export ARCUBE_DK2NU_DIR=/dvs_ro/cfs/cdirs/dune/users/mkramer/2x2EventGeneration/NuMI_dk2nu/newtarget-200kA_20220409
echo "===> 11 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export ARCUBE_EXPOSURE=1E15
echo "===> 12 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export ARCUBE_GEOM=geometry/Merged2x2MINERvA_v4/Merged2x2MINERvA_v4_noRock.gdml
echo "===> 13 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export ARCUBE_TUNE=AR23_20i_00_000
echo "===> 14 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export ARCUBE_RUN_OFFSET=0
echo "===> 15 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export ARCUBE_XSEC_FILE=/dvs_ro/cfs/cdirs/dune/users/mkramer/2x2EventGeneration/inputs/NuMI/genie_xsec-3.04.00-noarch-AR2320i00000-k250-e1000/v3_04_00/NULL/AR2320i00000-k250-e1000/data/gxspl-NUsmall.xml
echo "===> 16 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
export ARCUBE_OUT_NAME=Tutorial.genie.nu
echo "===> 17 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out

for i in $(seq 0 1); do
    echo "===> 18 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out
    ARCUBE_INDEX=$i ./run_genie.sh > $TWOBYTWO_SIM/../sb.output &
done
echo "===> 19 :)" >> ~/Projects/HEP-CCE-PAW/2x2_sim_worked/IRI/output.out

wait

