FROM ubuntu:18.04
LABEL author="Ville Kopio <ville.kopio@gmail.com>"

WORKDIR /app

RUN apt-get -yq update
RUN apt-get -yq  --no-install-suggests --no-install-recommends install \
    ca-certificates \
    curl \
    gnupg2

# Add the Cloud SDK distribution URI as a package source
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get -yq update
RUN apt-get -yq  --no-install-suggests --no-install-recommends install \
    google-cloud-sdk \
    kubectl

# Set gcloud default config
RUN gcloud config set project satakuntatalo-services
RUN gcloud config set compute/zone europe-north1-c

ENV GOOGLE_APPLICATION_CREDENTIALS=/app/key.json

COPY . .

ENTRYPOINT /bin/bash
