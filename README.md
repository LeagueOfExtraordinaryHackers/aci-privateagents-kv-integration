# Build a private ACI-based Azure Devops agent infrastructure (with private Keyvault access)

[![Build Status](https://cavertes.visualstudio.com/VW_Sharing/_apis/build/status/aci-privateagents-kv-integration?branchName=master)](https://cavertes.visualstudio.com/VW_Sharing/_build/latest?definitionId=3&branchName=master)

This repository shows how to build a scalable pool of Azure DevOps ACI-based agents that have private access to a secured Keyvault to retrieve secrets (in this case, an SSH private key) to operate over air-gapped resources in Azure. 

Particular attention has been placed on security: the example secrets generated and upload in the pipeline is further made unaccessible by the Azure DevOps Service Connection by locking down the Keyvault access policy.


### Implementation 

The repository consist of two modules (in `src/terraform/modules`):

- A `common` module to build the basic infrastructure:
  - A resource group
  - A vnet and a subnet
  - A managed identity
  - A Keyvault
  - An access policy to allow upload of secrets to the current SP (the one terraform is running on)
  - An access policy to allow the MI to read secrets
  - an SSH key and uploads

- An `aci-devops-agents` module that creates:
  - data structures for the vnet/subnet created before
  - an `azurerm_network_profile` and `azurerm_container_group` that deploy a container running the Azure DevOps agents in the vnet (which requires delegation to `Microsoft.ContainerInstance/containerGroups`)
  - The agents autamatically register themsleves with Azure DevOps.

  The pipeline in `src/pipelines/infra.yaml` applies the content on the `main.tf` in `src/terrafomr` which calls the `common` module and the `aci-devops-agents` module in sequence; after that, a call to the terrafom template in `src/terraform/delete_access_policy` eliminates the access policy for the `current` service connection (SC) service principal (SP) effectively removing access to the secret to subsequent Azure DevOps runs. This way, even by accessing the SC' SP will make it impossible to access the secrets in Keyvault.


### Extra:

We added (under `src/scripts`):

- A script to populate a Variable group from a set of key/values (TODO: use a YAML formatted file as input): `create_vg.sh`
- A python module to delete agents from a pool. As the [official Azure DevOps CLI extension for Azure CLI](https://github.com/Azure/azure-devops-cli-extension) does not suppoer yet ([issue](https://github.com/Azure/azure-devops-cli-extension/issues/955)) we thought it would be handy to have a module to implemnt such functionality in a script (TODO: implement the module in a cli command)

### Scenario:

Deploy an app to a private vnet, using secrets stored in a private KV, using ACI as AzDo agents. No secrets shall be exposed to the outside world.
Implementation:

Please see a list of [Contributors](CONTRIBUTORS.md) and the [security](security.md) document associated with this repo. This content is available under the [MIT license](LICENSE).