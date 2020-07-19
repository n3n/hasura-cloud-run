# Hasura on Cloud Run

## Deploy

[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.png)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/n3n/hasura-cloud-run.git)

### Deploy manually

```bash
# Set project id
$ export PROJECT_ID=""

# Build image
$ gcloud builds submit \
  --tag gcr.io/$PROJECT_ID/hasura \
  --timeout=720s \
  --project $PROJECT_ID

# Deploy cloud run
$ gcloud run deploy hasura --image gcr.io/$PROJECT_ID/hasura \
  --platform managed \
  --project $PROJECT_ID \
  --region asia-east1 \
  --allow-unauthenticated \
  --set-env-vars "ENABLE_MIGRATIONS=true" \
  --set-env-vars "HASURA_GRAPHQL_DATABASE_URL=DATABASE_URI" \
  --set-env-vars "HASURA_GRAPHQL_ENABLE_CONSOLE=true"
```

See more [configuration](https://hasura.io/docs/1.0/graphql/manual/deployment/graphql-engine-flags/reference.html)

## Connect to Cloud SQL

Enable connecting to a Cloud SQL https://cloud.google.com/sql/docs/postgres/connect-run#console


The connection should look something like this:

```bash
postgres://<user>:<password>@/<database>?host=/cloudsql/<instance_name>
```
You need to replace DATABASE_URI above with this connection string.

Reference https://stackoverflow.com/a/58513078
