FROM google/cloud-sdk:alpine

LABEL version="1.1.0"

RUN apk add --no-cache \
    bash \
    curl \
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

RUN gcloud components update --quiet && gcloud components install kubectl --quiet

# configure gcloud git helper for CSR usage
RUN git config --global credential.helper gcloud.sh

RUN helm version --client && gcloud version

