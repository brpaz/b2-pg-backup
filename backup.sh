#!/usr/bin/env sh
# This script connects to a Postgres database, executes pg_dump with the specified options and uploads the generated file to a Backbalze bucket.
# The following environment variables are required:
#   - PG_HOST: The host for the Postgres instance to run pg_dump.
#   - PG_PORT: The port for the Postgres instance to run pg_dump.
#   - PG_USER: Username to authenticate on the Postgres instance.
#   - PG_PASSWORD: Password to authenticate on the Postgres instance.
#   - PG_DUMP_DBS: A spsace separated list of databases to backup.
#   - PG_DUMP_ARGS: A space seperated string of custom args to pass to the "pg_dump" commands.
#   - B2_APPLICATION_KEY_ID: Backblaze Application KEY ID
#   - B2_APPLICATION_KEY: Backblaze Application Key
#   - B2_BUCKET: Backblaze Bucket to store the backups.

set -e
set -o pipefail

PG_PORT="${PG_PORT:=5432}"
DATABASES=${PG_DUMP_DBS}

function log() {
    echo $(date +"%Y-%m-%dT%H:%M:%S%z"): $1
}

function validate_args() {

    if [[ -z "${PG_HOST}" ]];
    then
        echo "Envrionment vartiable PG_HOST must be set"
        exit 1
    fi

    if [[ -z "${PG_USER}" ]];
    then
        echo "Envrionment vartiable PG_USER must be set"
        exit 1
    fi

    if [[ -z "${PG_PASSWORD}" ]];
    then
        echo "Envrionment vartiable PG_PASSWORD must be set"
        exit 1
    fi

    if [[ -z "${PG_DUMP_DBS}" ]];
    then
        echo "Envrionment vartiable PG_DUMP_DBS must be set"
        exit 1
    fi

    if [[ -z "${B2_APPLICATION_KEY_ID}" ]];
    then
        echo "Envrionment vartiable B2_APPLICATION_KEY_ID must be set"
        exit 1
    fi

    if [[ -z "${B2_APPLICATION_KEY}" ]];
    then
        echo "Envrionment vartiable B2_APPLICATION_KEY must be set"
        exit 1
    fi

    if [[ -z "${B2_BUCKET}" ]];
    then
        echo "Envrionment vartiable B2_BUCKET must be set"
        exit 1
    fi
}



validate_args


# Withnout this call next calls of date functions returns empty
date

TS=`date "+%Y%m%d_%H%M%S"`

BACKUP_DIR=pg_backup-${TS}
mkdir -p ${BACKUP_DIR}
cd $BACKUP_DIR

log ${BACKUP_DIR}

for DB in ${DATABASES}; do
    log "Backing up ${DB} database"
    PGPASSWORD="${PG_PASSWORD}" pg_dump -U ${PG_USER} -h ${PG_HOST} -p ${PG_PORT} ${PG_DUMP_ARGS} ${DB} | gzip > ${TS}-${DB}.gz
done

log "Preparing to Upload fies"

b2 authorize-account ${B2_APPLICATION_KEY_ID} ${B2_APPLICATION_KEY}

b2 sync $(pwd) "b2://${B2_BUCKET}"

log "Backup Done"
