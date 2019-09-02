FROM nginx:latest
USER root

ARG INSTANCE_NAME=panong-test-inspec-instance
ARG PROJECT_NAME=inspecplaygroundgcp

# Go, Make, Docker, Python, jq, git, ruby
RUN apt-get -qq update -y && \
    apt-get -qq upgrade -y && \
    apt-get -qq install --no-install-recommends --no-install-suggests -y \
      zip jq libffi-dev openssl wget curl \
      gcc libc-dev build-essential unzip \
      golang-go make git openrc vim \
      python3 python3-dev python3-pip \
      libffi-dev libssl-dev gnupg docker.io \
      zlib1g-dev ruby-full openssh-server \
    && pip3 install --no-cache-dir --upgrade pip \
    && ln -s /usr/bin/python3 /usr/bin/python

# Python requirements
RUN pip install -qU pip setuptools \
  && wget -qO /usr/bin/docker-compose https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` \
  && chmod +x /usr/bin/docker-compose

# GCloud Requirements
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
  && apt-get -qq update -y \
  && apt-get -qq install google-cloud-sdk -y

# Ruby requirements
RUN gem install -q --silent --no-ri --no-rdoc bundler ffi \
  etc nokogiri inspec-bin bigdecimal inspec_tools \
  ed25519 bcrypt_pbkdf

# Configure Nginx
COPY nginx.conf /etc/nginx/nginx.conf

RUN cat /etc/nginx/nginx.conf \
  && nginx -t

# Configure Inspec to ssh into GCP Compute Servers
COPY inspec /home/root/inspec
COPY creds.json /home/root

RUN gcloud auth activate-service-account --key-file=/home/root/creds.json \
  && gcloud config set project ${PROJECT_NAME}

RUN eval `ssh-agent -s` \
  && mkdir -p /root/.ssh \
  && chmod 0700 /root/.ssh \
  && gcloud compute ssh root@${INSTANCE_NAME} --zone us-east1-b --quiet

WORKDIR /home/root/inspec/gcp