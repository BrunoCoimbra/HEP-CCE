# Running CVMFS on HPC sites

## Frontier Squid
HPC worker nodes typically don't have access to the internet, so they can't access the CVMFS repositories. To solve this problem, we can spawn a Frontier Squid on an edge node to cache CVMFS files. The worker nodes have access to the edge node, so they can access the CVMFS files through the Frontier Squid.

### Running Frontier Squid with Apptainer
```sh
mkdir -p ~/scratch/squid/{cache,log}
apptainer run --writable-tmpfs \
  -B ~/scratch/squid/cache:/var/cache/squid \
  -B ~/scratch/squid/log:/var/log/squid \
  docker://opensciencegrid/frontier-squid:3.6-release
```

### Setting up cvmfsexec
```sh
git clone https://github.com/cvmfs/cvmfsexec.git
cd cvmfsexec
./makedist osg
echo "CVMFS_HTTP_PROXY=http://$(hostname -i):3128" > dist/etc/cvmfs/config.d/polaris.conf
CVMFSEXEC=$(pwd)/cvmfsexec/cvmfsexec
```

### Running cvmfsexec from the worker node
```sh
qsub -I -l select=1 -l filesystems=home:eagle -l walltime=1:00:00 -q debug -A hep-cce -v CVMFSEXEC=$CVMFSEXEC
$CVMFSEXEC dune.opensciencegrid.org -- ls /cvmfs
```

## cvmfsexec documentation
- https://indico.cern.ch/event/885212/contributions/4120683/attachments/2181040/3684201/CernVMWorkshopCvmfsExec20210201.pdf