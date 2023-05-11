FROM google/cloud-sdk:alpine

ARG KUBE_VERSION
ARG KUBE_BINARY_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64"

LABEL version="1.6.4"

RUN apk add --no-cache \
    bash \
    curl \
    gettext \
    jq \
    git \
    openssh-client \
    openssl \
    python3 \
    py3-pip

# install docker
COPY --from=docker:18 /usr/local/bin/docker* /usr/local/bin/

RUN pip install --upgrade pip

# install docker-compose
RUN apk add --no-cache --virtual build-deps \
    gcc \
    python3-dev \
    libffi-dev \
    openssl-dev \
    libc-dev \
    make \
 && pip install docker-compose \
 && apk del build-deps

RUN curl -sSL https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash; \
    helm init --client-only

# configure gcloud git helper for CSR usage
RUN git config --global credential.helper gcloud.sh

# Install cfssl and cfssljson
RUN curl -sSL https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 > /usr/bin/cfssl \
 && curl -sSL https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 > /usr/bin/cfssljson \
 && chmod +x /usr/bin/cfssl /usr/bin/cfssljson

RUN mkdir -p /tmp/helmfile; \
    curl -sSL https://github.com/helmfile/helmfile/releases/download/v0.153.1/helmfile_0.153.1_linux_amd64.tar.gz -o /tmp/helmfile/helmfile.tar.gz; \
    tar xvzf /tmp/helmfile/helmfile.tar.gz -C /tmp/helmfile; \
    mv /tmp/helmfile/helmfile /usr/bin/helmfile; \
    chmod +x /usr/bin/helmfile;

RUN helm plugin install https://github.com/databus23/helm-diff --version v3.7.0

# Install kubectl and kubeadm
RUN curl -sSL ${KUBE_BINARY_URL}/kubectl -o /usr/bin/kubectl \
 && curl -sSL ${KUBE_BINARY_URL}/kubeadm -o /usr/bin/kubeadm \
 && chmod +x /usr/bin/kubectl /usr/bin/kubeadm

