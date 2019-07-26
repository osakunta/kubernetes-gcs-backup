#!/bin/sh

# Ensure there is a directory for the backup
mkdir -p /app/${POSTGRES_DB}

gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
gcloud container clusters get-credentials satakuntatalo-cluster
