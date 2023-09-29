#!/bin/bash

# get mxnet and apply patches
git clone --single-branch --depth 1 --branch v1.3.x --recursive https://github.com/apache/incubator-mxnet
cp patch/Makefile incubator-mxnet/
cp patch/config.mk incubator-mxnet/make/
cp patch/mshadow.mk incubator-mxnet/3rdparty/mshadow/make/
cp patch/new* incubator-mxnet/src/operator/custom/

# get pip2 on great-lakes
python2 get-pip.py --user
