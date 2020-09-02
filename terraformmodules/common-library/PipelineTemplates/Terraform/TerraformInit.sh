#!/bin/bash
#set -e
repoPath=$1
environment=$2

cd $repoPath/Terraform

terraform init -upgrade -input=false \
-backend-config="./Config/backend.$environment.tfvars" \
-backend-config="subscription_id=$VPSUBSCRIPTIONID" \
-backend-config="tenant_id=$tenantId" \
-backend-config="client_id=$servicePrincipalId" \
-backend-config="client_secret=$servicePrincipalKey"

terraform workspace new $environment 2> /dev/null
terraform workspace select $environment