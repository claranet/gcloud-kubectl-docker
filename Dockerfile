FROM google/cloud-sdk:alpine

RUN apk add --no-cache \
    bash \
    curl \
    jq \
    git \
    openssh-client \
    openssl \
    python \
    py2-pip \
    docker

RUN pip install --upgrade pip \
    && pip install docker-compose

RUN curl -L https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash; \
    helm init --client-only

RUN gcloud components update --quiet && gcloud components install kubectl --quiet

RUN helm version --client && gcloud version

