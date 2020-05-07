FROM ubuntu:18.04

ARG agentversion=2.166.4
ENV agentversion=${agentversion}

RUN apt-get update &&  apt-get install -y wget && wget -q https://vstsagentpackage.azureedge.net/agent/$agentversion/vsts-agent-linux-x64-$agentversion.tar.gz && tar zxvf vsts-agent-linux-x64-$agentversion.tar.gz && rm vsts-agent-linux-x64-$agentversion.tar.gz && ls && ./bin/installdependencies.sh

ENTRYPOINT [ "/bin/bash", "-c", "./config.sh --unattended --replace && ./run.sh" ]