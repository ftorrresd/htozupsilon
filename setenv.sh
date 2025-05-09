#!/usr/bin/env bash

export pybind11_DIR="/cvmfs/sft.cern.ch/lcg/views/LCG_107a/x86_64-el9-gcc14-opt/lib/python3.11/site-packages/pybind11/share/cmake/pybind11"

source /cvmfs/sft.cern.ch/lcg/views/LCG_107a/x86_64-el9-gcc14-opt/setup.sh

python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip
pip install scikit_build_core


export PATH="$PATH:$(pwd)"
