#!/bin/bash
#set -e
repoPath=$1
environment=$2

cd $repoPath/Terraform
ls -Flah
ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)
terraform plan -out $environment.tfplan -input=false \
-var-file="./Config/config.$environment.tfvars" \
-var="subscription_id=$ARM_SUBSCRIPTION_ID" \
-var="tenant_id=$tenantId" \
-var="client_id=$servicePrincipalId" \
-var="client_secret=$servicePrincipalKey"