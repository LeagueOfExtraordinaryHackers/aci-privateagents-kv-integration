A module to deploy a common infrastructure for our ACI-backed, MI-enabled, KV-managed-storage Azure DevOps agents

Creates:

- A resource group
- A VNET and subnet
- A KV
- Adds a KV policy to create/get secrets for the SP Terraform runs on.
- A storage account (that will later be managed by the KV)