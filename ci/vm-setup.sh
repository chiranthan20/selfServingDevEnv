#!/bin/bash
rg_name=$1
sa_name=$2
container_name=$3
productName=$4

echo "creating tfstate storageaccount & container"

# Create the backend file automatically
touch ${productName}.tfbackend
echo "key=\"${productName}.tfstate\"" >> ${productName}.tfbackend
echo "resource_group_name=\"$rg_name\"" >> ${productName}.tfbackend
echo "storage_account_name=\"$sa_name\"" >> ${productName}.tfbackend
echo "container_name=\"$container_name\"" >> ${productName}.tfbackend
cat ${productName}.tfbackend
cp ${productName}.tfbackend ./backends/${productName}.tfbackend

#Create Resource Group If not Exists
is_rg_exists=$(az group exists --name $rg_name)

if ! $is_rg_exists ; then
    echo "Creating the Resource Group"
    az group create --location westeurope --name $rg_name --only-show-errors
fi

# Create Storage Account if it does not exist
tf_state_exists=$(az storage account check-name --name $sa_name --query "nameAvailable")

if $tf_state_exists ; then
    echo "Creating the Storage Account"
    az storage account create --location westeurope --name $sa_name --min-tls-version TLS1_2 --sku Standard_LRS --resource-group $rg_name --access-tier Hot --kind StorageV2 --only-show-errors
fi


# Create Container within the Storage Account if it does not exist
tf_container_exists=$(az storage container exists  --name $container_name --account-name $sa_name --auth-mode login --query "exists")

echo $tf_container_exists

if ! $tf_container_exists ; then
    echo "Creating the container to store terraform state"
    az storage container create --name $container_name --account-name $sa_name --public-access blob --auth-mode login --only-show-errors
fi
