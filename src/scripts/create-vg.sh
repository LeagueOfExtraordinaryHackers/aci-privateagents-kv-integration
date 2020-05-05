#!/bin/sh

#first add the azdo extension
#az extension add -n azure-devops
#
#Todo: parse a file with key:value pairs and apply

ORG="https://dev.azure.com/cavertes"
PROJECT='VW Sharing'

VG_NAME="TFBackend"

#make sure the VG is deleted

VG_ID=`az pipelines variable-group list --organization $ORG --project "$PROJECT" --query "[?name=='$VG_NAME']".id -o tsv`
[[ ! -z "$VG_ID" ]] &&  az pipelines variable-group delete --organization $ORG --project "$PROJECT" --id $VG_ID --yes

#create a new VG
VG_ID=`az pipelines variable-group create --authorize true --organization $ORG --project "$PROJECT" --name $VG_NAME --variables dummy=dummy --query id -o tsv`

echo "VG ID is $VG_ID"

#populate with variables
az pipelines variable-group variable create --organization $ORG --project "$PROJECT" --id $VG_ID --name backendContainerName --value tfstate
az pipelines variable-group variable create --organization $ORG --project "$PROJECT" --id $VG_ID --name backendStorageAccountName --value tfme
az pipelines variable-group variable create --organization $ORG --project "$PROJECT" --id $VG_ID --name backendStorageAccountSKU --value Standard_LRS
az pipelines variable-group variable create --organization $ORG --project "$PROJECT" --id $VG_ID --name backendStorageResourceGroupName --value storage
az pipelines variable-group variable create --organization $ORG --project "$PROJECT" --id $VG_ID --name location --value "westeurope"
az pipelines variable-group variable create --organization $ORG --project "$PROJECT" --id $VG_ID --name service_connection --value azuresc-alvozza
