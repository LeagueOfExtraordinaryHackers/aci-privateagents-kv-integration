# Build a private ACI-based Azure Devops agent infrastructure (with private Keyvault access)

[![Build Status](https://cavertes.visualstudio.com/VW_Sharing/_apis/build/status/aci-privateagents-kv-integration?branchName=master)](https://cavertes.visualstudio.com/VW_Sharing/_build/latest?definitionId=3&branchName=master)


This repo shows how to build a scalable pool of Azure DevOps ACI-based agents that have private access to a secured Keyvault to retrieve secrets (in this case, an SSH private key) to operate over air-gapped resources in Azure. 
