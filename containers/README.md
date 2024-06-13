# HEP-CCE Containers

## Building Containers

Containers are too large to be stored in a git repository. Instead, we store Apptainer definition files that can be used to build the containers locally. To build a container, you will need to have the Apptainer CLI installed. You can install it with the following command:

```bash
apptainer build [container_name].sif [container_name].def
```