# Running CVMFS on HPC sites

## Frontier Squid
HPC worker nodes may not provide access to CVMFS. To work around this limitation, we can use CVMFSEXEC to mount and access CVMFS on the worker nodes. Additionally, HPC worker nodes often have limited internet connectivity. While some sites provide local proxies to enable external access, if this is not an option, a Squid proxy server running in a container on an edge node can be used instead.

### Setting up cvmfsexec
```sh
CVMFSEXEC_DIR=/eagle/hep-cce/cvmfsexec
git clone https://github.com/cvmfs/cvmfsexec.git $CVMFSEXEC_DIR
cd $CVMFSEXEC_DIR
./makedist osg
CVMFSEXEC=$CVMFSEXEC_DIR/cvmfsexec
```

### Running Frontier Squid with Apptainer (Optional)
```sh
mkdir -p ~/scratch/squid/{cache,log}
apptainer run --writable-tmpfs \
  -B ~/scratch/squid/cache:/var/cache/squid \
  -B ~/scratch/squid/log:/var/log/squid \
  docker://opensciencegrid/frontier-squid:3.6-release

echo "CVMFS_HTTP_PROXY=http://$(hostname -i):3128" > $CVMFSEXEC_DIR/dist/etc/cvmfs/default.local
```

### Running cvmfsexec from the worker node
```sh
qsub -I -l select=1 -l filesystems=home:eagle -l walltime=1:00:00 -q debug -A hep-cce -v CVMFSEXEC=$CVMFSEXEC
$CVMFSEXEC dune.opensciencegrid.org -- ls /cvmfs
```

## cvmfsexec documentation
- https://indico.cern.ch/event/885212/contributions/4120683/attachments/2181040/3684201/CernVMWorkshopCvmfsExec20210201.pdf
