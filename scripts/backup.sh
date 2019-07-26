#!/bin/sh
. /app/scripts/init.sh

echo "Staring to backup database '${POSTGRES_DB}' (with user ${POSTGRES_USER}) from '${DB_POD}'"

kubectl exec ${DB_POD} --namespace=${NAMESPACE} -- \
    /bin/sh -c "pg_dump -U ${POSTGRES_USER} ${POSTGRES_DB} -Z 9" \
    > /app/${POSTGRES_DB}/${POSTGRES_DB}_backup.sql.gz

gsutil rsync -c /app/${POSTGRES_DB} gs://${BACKUP_BUCKET}/${POSTGRES_DB}
