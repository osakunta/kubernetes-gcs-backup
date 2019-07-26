#!/bin/sh
gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
gcloud container clusters get-credentials satakuntatalo-cluster
