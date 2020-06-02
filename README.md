# Build a private ACI-based Azure Devops agent infrastructure (with private Keyvault access)

[![Build Status](https://cavertes.visualstudio.com/VW_Sharing/_apis/build/status/aci-privateagents-kv-integration?branchName=master)](https://cavertes.visualstudio.com/VW_Sharing/_build/latest?definitionId=3&branchName=master)

Deploy an app to a private vnet, using secrets stored in a private KV, using ACI as AzDo agents. No secrets shall be exposed to the outside world.

For more information on the rationale behind this, check the [scenario document](scenario.md).

Access to generated secrets and downloading them in a pipeline is not possible for the Azure DevOps Service Connection as it's blocked by the KeyVault Access Policy.


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
- A python module to delete agents from a pool. As the [official Azure DevOps CLI extension for Azure CLI](https://github.com/Azure/azure-devops-cli-extension) does not support it yet ([issue](https://github.com/Azure/azure-devops-cli-extension/issues/955)) we thought it would be handy to have a module to implemnt such functionality in a script (TODO: implement the module in a cli command)

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments. Please see a list of [Contributors](CONTRIBUTORS.md) to this project. This content is available under the [MIT license](LICENSE).suppor