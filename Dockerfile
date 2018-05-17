FROM google/cloud-sdk:alpine

LABEL version="1.2.1"

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

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

# configure gcloud git helper for CSR usage
RUN git config --global credential.helper gcloud.sh

RUN helm version --client && gcloud version

