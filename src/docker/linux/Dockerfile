FROM ubuntu:18.04

ARG agentversion=2.166.4
ARG tfversion=0.12.24
ENV agentversion=${agentversion}
ENV tfversion=${tfversion}

ENV AGENT_ALLOW_RUNASROOT 1

WORKDIR /agent

RUN useradd vsts

ADD https://vstsagentpackage.azureedge.net/agent/$agentversion/vsts-agent-linux-x64-$agentversion.tar.gz .

RUN tar zxvf vsts-agent-linux-x64-$agentversion.tar.gz \
    && rm vsts-agent-linux-x64-$agentversion.tar.gz \
    && ./bin/installdependencies.sh \
    && chown -R vsts:vsts /agent

RUN apt-get update && apt-get install -y \
    unzip \
    && rm -rf /var/lib/apt/lists/*

ADD https://releases.hashicorp.com/terraform/$tfversion/terraform_${tfversion}_linux_amd64.zip .

RUN  unzip terraform_${tfversion}_linux_amd64.zip \
    && mv terraform /usr/bin \
    && rm terraform_${tfversion}_linux_amd64.zip \
    && alias tf='terraform'

USER vsts

# added 30 seconds sleep time to let the time to the ACI to get access to the Internet, otherwise, got some timeout on the agent registration...
ENTRYPOINT [ "/bin/bash", "-c", "sleep 30 && ./config.sh --unattended --replace && ./run.sh" ]