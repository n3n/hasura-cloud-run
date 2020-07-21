# Hasura on Cloud Run

## Deploy

[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.png)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/n3n/hasura-cloud-run.git)

### Deploy manually

```bash
# Set project id
export PROJECT_ID=""
export CLOUD_REGION=""
export APP_NAME="hasura-cloud-run"
export HASURA_ADMIN_SECRET=""
export PROJECT_DB_ID=""
export DB_NAME=""
export DB_USER=""
export DB_PASS=""

# Build image 
# Warning: this command won't work if cloned repo is in Windows filesystem. In this case use Linux or Deploy Button above. More details in issue #2
gcloud builds submit . \
  --tag gcr.io/$PROJECT_ID/$APP_NAME \
  --timeout=720s \
  --project $PROJECT_ID

# Deploy cloud run
gcloud run deploy $APP_NAME \
  --image gcr.io/$PROJECT_ID/$APP_NAME \
  --platform managed \
  --project $PROJECT_ID \
  --region $CLOUD_REGION \
  --allow-unauthenticated \
  --set-cloudsql-instances "$PROJECT_ID:$CLOUD_REGION:$PROJECT_DB_ID" \
  --set-env-vars "HASURA_GRAPHQL_DATABASE_URL=postgres://$DB_USER:$DB_PASS@/$DB_NAME?host=/cloudsql/$PROJECT_ID:$CLOUD_REGION:$PROJECT_DB_ID" \
  --set-env-vars "HASURA_GRAPHQL_ADMIN_SECRET=$HASURA_ADMIN_SECRET" \
  --set-env-vars "ENABLE_MIGRATIONS=true" \
  --set-env-vars "HASURA_GRAPHQL_ENABLE_CONSOLE=true" \
  --set-env-vars "HASURA_GRAPHQL_DEV_MODE=false"
```

See more [configuration](https://hasura.io/docs/1.0/graphql/manual/deployment/graphql-engine-flags/reference.html)

## Explanation:
### Connect to Cloud SQL


Instead of `--set-cloudsql-instances` above, you can manually set connection as explained here:
Enable connecting to a Cloud SQL https://cloud.google.com/sql/docs/postgres/connect-run#console

### Connection string
The connection should look something like this:

```bash
postgres://<user>:<password>@/<database>?host=/cloudsql/<instance_name>
```
You need to replace DATABASE_URI above with this connection string.

Reference https://stackoverflow.com/a/58513078
