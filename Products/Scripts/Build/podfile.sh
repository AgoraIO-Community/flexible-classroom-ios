#!/bin/sh
# cd this file path
cd $(dirname $0)
echo pwd: `pwd`

# parameters
Dependency_Type=$1

python ./cloud_pod.py ${Dependency_Type} 1 