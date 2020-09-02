#!/bin/bash
#set -e
repoPath=$1
environment=$2

cd $repoPath/Terraform
terraform apply $environment.tfplan