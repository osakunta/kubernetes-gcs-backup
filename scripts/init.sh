#!/bin/sh
if [ -z "$DB_POD" ]; then
    echo "Environment variable DB_POD must be set, exiting"
    exit 1
fi

export BACKUP_FILE="${POSTGRES_DB}_backup.sql.gz"
export BACKUP="${POSTGRES_DB}/${BACKUP_FILE}"

# Ensure there is a directory for the backup
mkdir -p /app/${POSTGRES_DB}

gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
gcloud container clusters get-credentials satakuntatalo-cluster
