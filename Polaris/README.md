# 2x2_sim on Polaris

## Setup

### Pull Singularity images
```shell
cd /eagle/hep-cce/dune_2x2_sim/2x2Containers/images
# We could also try to use pull_singularity_container.sh
apptainer pull docker://mjkramer/sim2x2:genie_edep.3_04_00.20230912
apptainer pull docker://mjkramer/sim2x2:ndlar011
apptainer pull docker://fermilab/fnal-wn-sl7:latest
```

### Copy 2x2EventGeneration from NERSC
```shell
scp -r coimbra@perlmutter.nersc.gov:/dvs_ro/cfs/cdirs/dune/users/mkramer/2x2EventGeneration /eagle/hep-cce/dune_2x2_sim/from_nersc_mkramer
```

## Instructions

### Start base container

```shell
module use /soft/spack/gcc/0.6.1/install/modulefiles/Core
module load apptainer

WORK_DIR=/eagle/hep-cce/dune_2x2_sim
TWOBYTWO_SIM=$WORK_DIR/2x2_sim

# HACK because we forgot to include GNU time in some of the containers
# -B /usr/bin/time:$TWOBYTWO_SIM/tmp_bin/time
apptainer shell \
-B $WORK_DIR \
-B /soft/xalt \
-B /usr/bin/time:$TWOBYTWO_SIM/tmp_bin/time \
-B $WORK_DIR/external_data/cvmfs:/cvmfs \
-B $WORK_DIR/external_data/nersc_mkramer:/dvs_ro/cfs/cdirs/dune/users/mkramer \
--env TWOBYTWO_SIM=$TWOBYTWO_SIM \
/eagle/hep-cce/dune_2x2_sim/HEP-CCE/containers/images/dune_2x2_sim_base_container.sif
```

### GENIE

#### Step 1
```shell
cd $TWOBYTWO_SIM/run-genie

export ARCUBE_RUNTIME=SINGULARITY
export ARCUBE_DIR=/eagle/hep-cce/dune_2x2_sim/2x2_sim
export ARCUBE_CONTAINER_DIR=/eagle/hep-cce/dune_2x2_sim/2x2Containers/images
export ARCUBE_CONTAINER=sim2x2_genie_edep.3_04_00.20230912.sif
export ARCUBE_DET_LOCATION=MiniRun5-Nu
export ARCUBE_DK2NU_DIR=/dvs_ro/cfs/cdirs/dune/users/mkramer/2x2EventGeneration/NuMI_dk2nu/newtarget-200kA_20220409
export ARCUBE_EXPOSURE=1E15
export ARCUBE_GEOM=geometry/Merged2x2MINERvA_v4/Merged2x2MINERvA_v4_noRock.gdml
export ARCUBE_TUNE=AR23_20i_00_000
export ARCUBE_RUN_OFFSET=0
export ARCUBE_XSEC_FILE=/dvs_ro/cfs/cdirs/dune/users/mkramer/2x2EventGeneration/inputs/NuMI/genie_xsec-3.04.00-noarch-AR2320i00000-k250-e1000/v3_04_00/NULL/AR2320i00000-k250-e1000/data/gxspl-NUsmall.xml
export ARCUBE_OUT_NAME=Tutorial.genie.nu

for i in $(seq 0 9); do
    ARCUBE_INDEX=$i ./run_genie.sh &
done

wait
```

#### Step 2
```shell
cd $TWOBYTWO_SIM/run-genie

export ARCUBE_RUNTIME=SINGULARITY
export ARCUBE_DIR=/eagle/hep-cce/dune_2x2_sim/2x2_sim
export ARCUBE_CONTAINER_DIR=/eagle/hep-cce/dune_2x2_sim/2x2Containers/images
export ARCUBE_CONTAINER=sim2x2_genie_edep.3_04_00.20230912.sif
export ARCUBE_DET_LOCATION=MiniRun5-Rock
export ARCUBE_DK2NU_DIR=/dvs_ro/cfs/cdirs/dune/users/mkramer/2x2EventGeneration/NuMI_dk2nu/newtarget-200kA_20220409
export ARCUBE_EXPOSURE=1E15
export ARCUBE_GEOM=geometry/Merged2x2MINERvA_v4/Merged2x2MINERvA_v4_justRock.gdml
export ARCUBE_TUNE=AR23_20i_00_000
export ARCUBE_RUN_OFFSET=1000000000
export ARCUBE_XSEC_FILE=/dvs_ro/cfs/cdirs/dune/users/mkramer/2x2EventGeneration/inputs/NuMI/genie_xsec-3.04.00-noarch-AR2320i00000-k250-e1000/v3_04_00/NULL/AR2320i00000-k250-e1000/data/gxspl-NUsmall.xml
export ARCUBE_OUT_NAME=Tutorial.genie.rock

for i in $(seq 0 9); do
    ARCUBE_INDEX=$i ./run_genie.sh &
done

wait
```

### edep-sim

#### Step 1
```shell
cd $TWOBYTWO_SIM/run-edep-sim

export ARCUBE_RUNTIME=SINGULARITY
export ARCUBE_DIR=/eagle/hep-cce/dune_2x2_sim/2x2_sim
export ARCUBE_CONTAINER_DIR=/eagle/hep-cce/dune_2x2_sim/2x2Containers/images
export ARCUBE_CONTAINER=sim2x2_ndlar011.sif
export ARCUBE_GENIE_NAME=Tutorial.genie.nu
export ARCUBE_EDEP_MAC=macros/2x2_beam.mac
export ARCUBE_GEOM_EDEP=geometry/Merged2x2MINERvA_v4/Merged2x2MINERvA_v4_withRock.gdml
export ARCUBE_RUN_OFFSET=0
export ARCUBE_OUT_NAME=Tutorial.edep.nu

for i in $(seq 0 9); do
    ARCUBE_INDEX=$i ./run_edep_sim.sh &
done

wait
```

#### Step 2
```shell
cd $TWOBYTWO_SIM/run-edep-sim

export ARCUBE_RUNTIME=SINGULARITY
export ARCUBE_DIR=/eagle/hep-cce/dune_2x2_sim/2x2_sim
export ARCUBE_CONTAINER_DIR=/eagle/hep-cce/dune_2x2_sim/2x2Containers/images
export ARCUBE_CONTAINER=sim2x2_ndlar011.sif
export ARCUBE_GENIE_NAME=Tutorial.genie.rock
export ARCUBE_EDEP_MAC=macros/2x2_beam.mac
export ARCUBE_GEOM_EDEP=geometry/Merged2x2MINERvA_v4/Merged2x2MINERvA_v4_withRock.gdml
export ARCUBE_RUN_OFFSET=1000000000
export ARCUBE_OUT_NAME=Tutorial.edep.rock

for i in $(seq 0 9); do
    ARCUBE_INDEX=$i ./run_edep_sim.sh &
done

wait
```

### hadd

#### Step 1
```shell
cd $TWOBYTWO_SIM/run-hadd

export ARCUBE_RUNTIME=SINGULARITY
export ARCUBE_DIR=/eagle/hep-cce/dune_2x2_sim/2x2_sim
export ARCUBE_CONTAINER_DIR=/eagle/hep-cce/dune_2x2_sim/2x2Containers/images
export ARCUBE_CONTAINER=sim2x2_ndlar011.sif
export ARCUBE_IN_NAME=Tutorial.edep.nu
export ARCUBE_HADD_FACTOR=10
export ARCUBE_OUT_NAME=Tutorial.edep.nu.hadd
export ARCUBE_INDEX=0

./run_hadd.sh
```

#### Step 2
```shell
cd $TWOBYTWO_SIM/run-hadd

export ARCUBE_RUNTIME=SINGULARITY
export ARCUBE_DIR=/eagle/hep-cce/dune_2x2_sim/2x2_sim
export ARCUBE_CONTAINER_DIR=/eagle/hep-cce/dune_2x2_sim/2x2Containers/images
export ARCUBE_CONTAINER=sim2x2_ndlar011.sif
export ARCUBE_IN_NAME=Tutorial.edep.rock
export ARCUBE_HADD_FACTOR=10
export ARCUBE_OUT_NAME=Tutorial.edep.rock.hadd
export ARCUBE_INDEX=0

./run_hadd.sh
```

### Spill building

```shell
cd $TWOBYTWO_SIM/run-spill-build

export ARCUBE_RUNTIME=SINGULARITY
export ARCUBE_DIR=/eagle/hep-cce/dune_2x2_sim/2x2_sim
export ARCUBE_CONTAINER_DIR=/eagle/hep-cce/dune_2x2_sim/2x2Containers/images
export ARCUBE_CONTAINER=sim2x2_ndlar011.sif
export ARCUBE_NU_NAME=Tutorial.edep.nu.hadd
export ARCUBE_NU_POT=1E16
export ARCUBE_ROCK_NAME=Tutorial.edep.rock.hadd
export ARCUBE_ROCK_POT=1E16
export ARCUBE_OUT_NAME=Tutorial.spill
export ARCUBE_INDEX=0

./run_spill_build.sh
```

### MINERvA simulation

#### Step 1
```shell
cd $TWOBYTWO_SIM/run-edep2flat

export ARCUBE_RUNTIME=SINGULARITY
export ARCUBE_DIR=/eagle/hep-cce/dune_2x2_sim/2x2_sim
export ARCUBE_CONTAINER_DIR=/eagle/hep-cce/dune_2x2_sim/2x2Containers/images
export ARCUBE_CONTAINER=fnal-wn-sl7_latest.sif
export ARCUBE_IN_NAME=Tutorial.spill
export ARCUBE_OUT_NAME=Tutorial.edep2flat
export ARCUBE_INDEX=0

./run_edep2flat.sh
```


## Work Notes
- Using `singularity pull docker://mjkramer/${CONTAINER_NAME}` doesn't seem to include env variables in the resulting sif file
- Building the image locally seems to work:
    - Bootstrap: docker
    - From: mjkramer/sim2x2:genie_edep.3_04_00.20230620
- Preserving the env variables from the def file might not be needed
    - `2x2_sim/admin/container_env.${CONTAINER_NAME}.sif.sh` is called at run time by `2x2_sim/util/reload_in_container.inc.sh`
- We replaced `docker://sim2x2_genie_edep.LFG_testing.20230228.v2` with our `dune_2x2_sim_base_container`
- module is not available in Polaris


## Suggestions
- Make CVMFS available in Polaris
    - Distribute custom software, such as `2x2EventGeneration` through CVMFS
    - Distribute Singularity/Apptainer images as SIF files through CVMFS
        - This will enable us to drop `container_env.${CONTAINER_NAME}.sif.sh` scripts
        - SIF files generated by `singularity pull docker` won't keep environment variables