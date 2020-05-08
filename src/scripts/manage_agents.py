from azure.devops.connection import Connection
from msrest.authentication import BasicAuthentication
import os


class ManageAgents:
    def __init__(self):
        self.personal_access_token = os.environ["AZURE_DEVOPS_PAT"]
        self.organization_url = os.environ["AZURE_DEVOPS_ORG"]

    # Create a connection to the org
    def client_auth(self):
        credentials = BasicAuthentication('', self.personal_access_token)
        connection = Connection(
            base_url=self.organization_url, creds=credentials)
        return connection.clients_v5_1.get_task_agent_client()

    # Do some stuff with the agent pools
    def get_my_pools(self, filter=None):
        if filter is None:
            exit("[ERROR] No filter set")
        client = self.client_auth()
        get_agent_pools_response = client.get_agent_pools()
        for agent_pool in get_agent_pools_response:
            if (agent_pool.owner.unique_name == filter):
                print("")
                print("=================================")
                print("")
                print("ID: " + str(agent_pool.id) +
                      ", PoolName: " + agent_pool.name +
                      ", Owner: " + agent_pool.owner.unique_name)
                agent_pool_agents = client.get_agents(agent_pool.id)
                for agent in agent_pool_agents:
                    print("=> id: " + str(agent.id) +
                          ", name:" + agent.name +
                          ", os_description:" + str(agent.os_description) +
                          ", provisioning_state:" + str(agent.provisioning_state) +
                          ", status:" + str(agent.status))

    def delete_agents_from_my_pool(self, filter=None):
        if filter is None:
            exit("[ERROR] No filter set")
        client = self.client_auth()
        get_agent_pools_response = client.get_agent_pools()
        for agent_pool in get_agent_pools_response:
            if (agent_pool.owner.unique_name == filter):
                print("")
                print("=================================")
                print("")
                print("ID: " + str(agent_pool.id) +
                      ", PoolName: " + agent_pool.name +
                      ", Owner: " + agent_pool.owner.unique_name)
                agent_pool_agents = client.get_agents(agent_pool.id)
                for agent in agent_pool_agents:
                    print("=> id: " + str(agent.id) +
                          ", name:" + agent.name +
                          ", os_description:" + str(agent.os_description) +
                          ", provisioning_state:" + str(agent.provisioning_state) +
                          ", status:" + str(agent.status))

    def delete_my_pools(self, filter=None):
        if filter is None:
            exit("[ERROR] No filter set")
        client = self.client_auth()
        get_agent_pools_response = client.get_agent_pools()
        for agent_pool in get_agent_pools_response:
            if (agent_pool.owner.unique_name == filter):
                print("")
                print("=================================")
                print("")
                print("ID: " + str(agent_pool.id) +
                      ", PoolName: " + agent_pool.name +
                      ", Owner: " + agent_pool.owner.unique_name)
                client.delete_agent_pool(agent_pool.id)


#  Example Usage
manager = ManageAgents()
manager.get_my_pools("alvozza@microsoft.com")
# manager.delete_my_pools("alvozza@microsoft.com")
