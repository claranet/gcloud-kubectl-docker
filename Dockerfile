FROM google/cloud-sdk:alpine

RUN apk add --no-cache \
    bash \
    curl \
    jq \
    git \
    openssh-client \
    python \
    py2-pip \
    docker

RUN pip install --upgrade pip \
    && pip install docker-compose

RUN gcloud components update --quiet && gcloud components install kubectl --quiet
