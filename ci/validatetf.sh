#!/bin/bash
backend=$1
workingDir=$2
tfvarsFile=$3

echo "Set Azure ARM variables"
export ARM_CLIENT_ID=$servicePrincipalId
export ARM_CLIENT_SECRET=$servicePrincipalKey
export ARM_SUBSCRIPTION_ID=$(az account list --query "[?isDefault].id | [0]" | xargs)
export ARM_TENANT_ID=$tenantId

echo "Backend Configuration is: $backend"
cd $workingDir
cp ../provider.tf .
if [ -z ${backend-unset} ]; then
 echo "Init without Backend"
 terraform init
else 
 cp ../backends/$backend .
 cp ../backend.tf .
 terraform init -backend-config $backend
fi  
terraform validate
if [ $?  -eq 0 ]; then 
  echo "Terraform Validate is now Complete"; 
else 
  exit $?  
fi

if [ -z ${tfvarsFile-unset} ]; then
 terraform plan -out $workingDir.plan
else 
 echo $tfvarsFile
 terraform plan -var-file $tfvarsFile -out $workingDir.plan
fi
if [ $?  -eq 0 ]; then 
  echo "Terraform Plan is now Complete"; 
else 
  exit $?  
fi