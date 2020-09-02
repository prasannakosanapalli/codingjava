#!/bin/bash
repoPath=$1
environment=$2
serviceConnection=$3

cd $repoPath/Terraform

resourceGroupName=$(grep -i 'resource_group_name' "./Config/backend.$environment.tfvars" | awk -F'=' '{print $2}' | sed -e 's/"//g' | sed -e 's/ //g')
backendStorageAccount=$(grep -i 'storage_account_name' "./Config/backend.$environment.tfvars" | awk -F'=' '{print $2}' | sed -e 's/"//g' | sed -e 's/ //g')
containerName=$(grep -i 'container_name' "./Config/backend.$environment.tfvars" | awk -F'=' '{print $2}' | sed -e 's/"//g' | sed -e 's/ //g')
backendRegion=$(grep -i 'region' "./Config/backend.$environment.tfvars" | awk -F'=' '{print $2}' | sed -e 's/"//g' | sed -e 's/ //g')

echo "resourceGroupName:" $resourceGroupName
echo "backendStorageAccount:" $backendStorageAccount
echo "containerName:" $containerName
echo "backendRegion:" $backendRegion

set +e
subscriptionId=$(az account show --query id --out tsv)
echo "##vso[task.setvariable variable=VPsubscriptionId]$subscriptionId"
if [ $(az group exists -n $resourceGroupName -o tsv) = false ]
then
    echo "$resourceGroupName RG was not found. Please ensure the base infrastructure pipeline ran successfully and try again"
    exit -1
else
    echo "Using resource group $resourceGroupName"
fi
az storage account show -n $backendStorageAccount -g $resourceGroupName &> /dev/null
set -e
if [ $? -eq 0 ]
then
    echo "Using storage account $backendStorageAccount in resource group $resourceGroupName"
else
    echo "$backendStorageAccount storage account in resource group $resourceGroupName was not found."
    echo "Please ensure the base infrastructure pipeline ran successfully and try again"
    exit -1
fi
az storage container create --name $containerName --account-name $backendStorageAccount 