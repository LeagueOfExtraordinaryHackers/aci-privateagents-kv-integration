# Build a private ACI-based Azure Devops agent infrastructure (with private Keyvault access)

[![Build Status](https://cavertes.visualstudio.com/VW_Sharing/_apis/build/status/aci-privateagents-kv-integration?branchName=master)](https://cavertes.visualstudio.com/VW_Sharing/_build/latest?definitionId=3&branchName=master)


This repo shows how to build a scalable pool of Azure DevOps ACI-based agents that have private access to a secured Keyvault to retrieve secrets (in this case, an SSH private key) to operate over air-gapped resources in Azure. 

It deploys:

- A common module to build the basic infrastructure:
  - A resource group
  - A vnet and a subnet
  - A managed identity
  - A Keyvault
  - An access policy to allow upload of secrets to the current SP (the one terraform is running on)
  - An access policy to allow the MI to read secrets
  - an SSH key and uploads



  Scenario:

Deploy an app to a private vnet, using secrets stored in a private KV, using ACI as AzDo agents. No secrets shall be exposed to the outside world.
Implementation:

First pipeline ("infra") deploys:
RG
VNET+Subnet for KV & AzDO agents
KV
Generates a SSH key,
Uploads the key (both pub and priv) to the KV
Create an SP
Add access policy to KV for that SP, only to [GET] secrets
Locks down the KV to be accessible only from the AzDO private agent vnet
Second pipeline
[First part on public agents]
Deploys a second vnet and peers it to the AzDO priv agent vnet
Create an ACI agent
ACI agent registers with Azdo (name: aci-[unique ID]), needs the API token to do that
[Second part on ACI agent, need uniqueID to identify]
Deploy a VM in it with the public key from step one
Use the priv key from KV to SSH to the VM
Create a file on disk
ACI deregister itself from AzDO
