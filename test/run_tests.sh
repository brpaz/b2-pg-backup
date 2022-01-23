#!/usr/bin/env sh
# Runs Integration tests

set -e
set -o pipefail

if [[ -z "${IMAGE_TAG}" ]];
then
    echo "Envrionment vartiable IMAGE_TAG must be set"
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


echo "Starting Postgres container"
PGCONTAINER=$(docker run -d --rm -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_DB=test postgres:14)

sleep 10 # TODO replace this with healthcheck check

PG_IP_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${PGCONTAINER})

B2_FOLDER="test-$(date "+%Y%m%d_%H%M%S")"
TEST_BUCKET="${B2_BUCKET}/${B2_FOLDER}"

docker run \
    -e PG_HOST=${PG_IP_ADDRESS} \
    -e PG_USER="postgres" \
    -e PG_PASSWORD="mysecretpassword" \
    -e PG_DUMP_DBS="postgres" \
    -e B2_APPLICATION_KEY_ID=${B2_APPLICATION_KEY_ID} \
    -e B2_APPLICATION_KEY=${B2_APPLICATION_KEY} \
    -e B2_BUCKET="${TEST_BUCKET}" \
 $IMAGE_TAG

docker run --rm -e B2_APPLICATION_KEY_ID=${B2_APPLICATION_KEY_ID}  -e B2_APPLICATION_KEY=${B2_APPLICATION_KEY} tianon/backblaze-b2:3.2 b2 ls ${B2_BUCKET} ${B2_FOLDER}

# TODO check output for file presence