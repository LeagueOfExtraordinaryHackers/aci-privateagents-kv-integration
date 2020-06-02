## Scenario

This repo sprung up from a customer engagement in Commercial Software Engineering at Microsoft where we faced severe security requirements to perform computational jobs ("simulations") in an air-gapped environment in Azure. Due to the IP-sensitive nature of both the software and the data involved, a paramaount need for limiting as much as possible access to the VMs running the simulation was enforced; mainly, we wanted to make sure than no one could access the simulation VMs, except for the simulation Azure DevOps pipeline that starts the simulation and collect the results into a secure Azure Storage Blob account.

## Solution

We isolated the VMs into a VNET with a strict Network Security Group that blocks ingress and egress traffic; we peered that vnet with a secondary VNET with internet access; we then deploy a set of Azure DevOps agents in this secondary VNET that will act on the simulation VMs thru peering to start/stop/store the simulation runs.
