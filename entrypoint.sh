#!/bin/sh

set -e

log() {
    MESSAGE=$1
    echo $REVISION $MESSAGE
}

# wait for a port to be ready
wait_for_port() {
    local PORT=$1
    local HOST="localhost"

    if [ -n "$2" ]; then
      HOST="$2"
    fi

    log "waiting $HASURA_GRAPHQL_MIGRATIONS_SERVER_TIMEOUT for $HOST:$PORT to be ready"
    for i in `seq 1 $HASURA_GRAPHQL_MIGRATIONS_SERVER_TIMEOUT`;
    do
        nc -z $HOST $PORT > /dev/null 2>&1 && log "$HOST:$PORT is ready" && return
        sleep 1
    done
    log "failed waiting for $HOST:$PORT" && exit 1
}

# wait_for_port 5432 $POSTGRES_HOST

if [ "$ENABLE_MIGRATIONS" = true ]; then
  log "Running migrations in background"
  ./migrate.sh &
fi

log "Starting graphql engine on port $HASURA_GRAPHQL_SERVER_PORT"
exec graphql-engine serve

