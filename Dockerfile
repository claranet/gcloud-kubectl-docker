FROM google/cloud-sdk:alpine

ARG KUBE_VERSION

LABEL version="1.2.2"

RUN apk add --no-cache \
    bash \
    curl \
    gettext \
    jq \
    git \
    openssh-client \
    openssl \
    python \
    py2-pip

# install docker
COPY --from=docker:18 /usr/local/bin/docker* /usr/bin/

RUN pip install --upgrade pip \
    && pip install docker-compose

RUN curl -L https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash; \
    helm init --client-only

# configure gcloud git helper for CSR usage
RUN git config --global credential.helper gcloud.sh

# Install cfssl and cfssljson
RUN curl -sSL https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 > /usr/bin/cfssl \
 && curl -sSL https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 > /usr/bin/cfssljson \
 && chmod +x /usr/bin/cfssl /usr/bin/cfssljson

# Install kubectl and kubeadm
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl > /usr/bin/kubectl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubeadm > /usr/bin/kubeadm \
 && chmod +x /usr/bin/kubectl /usr/bin/kubeadm

