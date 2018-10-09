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

# Install kubectl and kubeadm
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl > /usr/bin/kubectl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubeadm > /usr/bin/kubeadm \
 && chmod +x /usr/bin/kubectl /usr/bin/kubeadm

# configure gcloud git helper for CSR usage
RUN git config --global credential.helper gcloud.sh

RUN helm version --client && gcloud version && kubectl version --client

