#!/bin/sh
if [ -z "$APP_POD" ]; then
    echo "Environment variable APP_POD must be set, exiting"
    exit 1
fi

. /app/scripts/init.sh

echo "Staring to restore database '${POSTGRES_DB}' (with user ${POSTGRES_USER}) from '${DB_POD}'"

gsutil cp gs://satakuntatalo-services-versioned-backup/${BACKUP} /app/${BACKUP}

echo "Stopping ${APP_POD}"
kubectl scale --replicas=0 -n ${NAMESPACE} ${APP_POD}

kubectl exec -i ${DB_POD} --namespace=${NAMESPACE} -- dropdb -U ${POSTGRES_USER} ${POSTGRES_DB}
kubectl exec -i ${DB_POD} --namespace=${NAMESPACE} -- createdb -U ${POSTGRES_USER} ${POSTGRES_DB}

gunzip -c /app/${BACKUP} | kubectl exec -i ${DB_POD} --namespace=${NAMESPACE} -- psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}

echo 'Database restored'
echo "Starting ${APP_POD}"
kubectl scale --replicas=1 -n ${NAMESPACE} ${APP_POD}
