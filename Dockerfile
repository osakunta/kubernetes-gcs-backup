FROM ubuntu:18.04 AS builder
LABEL author="Ville Kopio <ville.kopio@gmail.com>"

RUN apt-get -yq update
RUN apt-get -yq  --no-install-suggests --no-install-recommends install \
        ca-certificates \
        curl \
        gcc \
        gnupg2 \
        python-dev \
        python-pip \
        python-setuptools

# Install crcmod with C extensions to .local
RUN pip install --user --no-cache-dir -U crcmod


FROM ubuntu:18.04
LABEL author="Ville Kopio <ville.kopio@gmail.com>"

WORKDIR /app

# Copy the built crcmod package and add it to PATH
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

RUN apt-get -yq update && apt-get -yq --no-install-suggests --no-install-recommends install \
        ca-certificates \
        curl \
        gnupg2

# Add the Cloud SDK distribution URI as a package source
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get -yq update && apt-get -yq  --no-install-suggests --no-install-recommends install \
        google-cloud-sdk \
        kubectl

# Set gcloud default config
RUN gcloud config set project satakuntatalo-services
RUN gcloud config set compute/zone europe-north1-c

# Set default env vars
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/key.json
ENV NAMESPACE=production
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres
ENV BACKUP_BUCKET=satakuntatalo-services-versioned-backup

COPY . .

ENTRYPOINT /bin/bash
