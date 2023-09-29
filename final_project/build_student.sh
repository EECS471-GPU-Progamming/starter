#!/bin/bash
# The interpreter used to execute the script

#“#SBATCH” directives that convey submission options:

#SBATCH --job-name=makemxnet
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=4000m
#SBATCH --time=2:00:00
#SBATCH --account=eecs471w23_class

module load gcc/8.2.0
module load cudnn/11.6-v8.4.1
module load cuda/11.6.2
module load mkl/2022.0.2

cp -fv new-forward.cuh incubator-mxnet/src/operator/custom
make -C incubator-mxnet USE_CUDA=1 USE_CUDA_PATH=/sw/pkgs/arc/cuda/11.6.2 USE_CUDNN=1 USE_MKLDNN=0 USE_BLAS=mkl
exit_code=$(echo $?)
if [ $exit_code -ne  0 ]; then
    echo "Build Failed. Exiting"
    exit 1
fi
pip install --user -e incubator-mxnet/python

echo "Finished building mxnet"
