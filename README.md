Kubernetes GCS Backup
=====================
This utility is used to backup data from a Postgres database in Kubernetes cluster to a Google Cloud Storage bucket.

Setup
-----
A service account is used to access the Kubernetes cluster and GCS. A service account private key must be available in the container through `GOOGLE_APPLICATION_CREDENTIALS` environment variable. The default location is `/app/key.json`. Other environment variables to configure the container are:

- `NAMESPACE`: Cluster namespace (default: `production`)
- `POSTGRES_DB`: Database name (default: `postgres`)
- `POSTGRES_USER`: Database user (default: `postgres`)
- `BACKUP_BUCKET`: GCS bucket name (default: `satakuntatalo-services-versioned-backup`)

There are also environment variables that **must** be set as they don't have default values:

- `DB_POD`: Name of the pod that contains the database. It can also be the name of the deployment/statefulset and `kubectl` will choose the first pod it finds.
- `APP_POD`: Name of the pod that contains the app using the database. It can also be the name of the deployment and `kubectl` will choose the first pod it finds. This is used to scale down the app before database restoration and scale it back up again afterwards (TODO: make this optional and take the scale-up as an argument).
