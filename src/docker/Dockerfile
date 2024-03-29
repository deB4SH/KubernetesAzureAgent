FROM debian:bullseye-20230109-slim

LABEL MAINTAINER=deb4sh@github
LABEL org.opencontainers.image.source=https://github.com/deB4SH/KubernetesAzureAgent

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64
ENV DEBIAN_FRONTEND=noninteractive

# add user
RUN mkdir /azp
RUN useradd -ms /bin/bash worker
ENV PATH="$PATH:/home/worker/.local/bin"
RUN chown -R worker:worker /azp

#Install general dependencies
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    gnupg \
    software-properties-common \
    gettext-base \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

#Install Kubernetes
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update && apt-get install -y -qq --no-install-recommends kubectl \
    && rm -rf /var/lib/apt/lists/*

#Install KubeSeal
RUN curl -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.19.4/kubeseal-0.19.4-linux-amd64.tar.gz -o kubeseal-0.19.4-linux-amd64.tar.gz \
    && tar xfv kubeseal-0.19.4-linux-amd64.tar.gz -C /usr/local/bin

#Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

#Install Helm-Diff
ENV HELM_PLUGINS="/home/worker/.local/helm-plugin"
RUN  helm plugin install https://github.com/databus23/helm-diff

#Install Helmfile
RUN curl -L https://github.com/helmfile/helmfile/releases/download/v0.150.0/helmfile_0.150.0_linux_amd64.tar.gz -o  helmfile_0.150.0_linux_amd64.tar.gz && \
    tar xfv helmfile_0.150.0_linux_amd64.tar.gz -C /usr/local/bin

#Install Kustomize
RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.0.0/kustomize_v5.0.0_linux_amd64.tar.gz -o kustomize_v5.0.0_linux_amd64.tar.gz && \
    tar xfv kustomize_v5.0.0_linux_amd64.tar.gz -C /usr/local/bin

#Install DotNet
RUN wget https://dot.net/v1/dotnet-install.sh && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh -c 3.1
ENV PATH="$PATH:/root/.dotnet/"

#Install AzureCli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

WORKDIR /azp

COPY /src/docker/azure-scripts/start.sh .
COPY /src/docker/azure-scripts/installdependencies.sh .
COPY /src/docker/scripts/entrypoint.sh .
RUN chmod +x start.sh installdependencies.sh entrypoint.sh

RUN /azp/installdependencies.sh

USER worker
ENTRYPOINT [ "./entrypoint.sh", "-f", "/azp/init" ]
# FOR DEBUG PURPOSES
#ENTRYPOINT ["tail", "-f", "/dev/null"]
