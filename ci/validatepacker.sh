#!/bin/bash
pkrconfig=$1
workingDir=$2
pkrTemplate=$3
pkrVarsFilePath=$4
echo "Packer Configuration is: $pkrconfig"
cd $workingDir
packer init $pkrconfig
packer validate --var-file=$pkrVarsFilePath $pkrTemplate
if [ $?  -eq 0 ]; then 
  echo "Packer Validate is now Complete for $pkrTemplate"
else 
  exit $?  
fi
