FROM ubuntu:18.04

ARG agentversion=2.166.4
ENV agentversion=${agentversion}

ENV AGENT_ALLOW_RUNASROOT 1

WORKDIR /agent

RUN apt-get update &&  apt-get install -y apt-transport-https git wget && wget -q https://vstsagentpackage.azureedge.net/agent/$agentversion/vsts-agent-linux-x64-$agentversion.tar.gz && tar zxvf vsts-agent-linux-x64-$agentversion.tar.gz && rm vsts-agent-linux-x64-$agentversion.tar.gz && ls && ./bin/installdependencies.sh

ENTRYPOINT [ "/bin/bash", "-c", "./config.sh --unattended --replace && ./run.sh" ]