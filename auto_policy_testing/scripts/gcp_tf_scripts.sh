#!/bin/bash

RESOURCE_NAME=$1
REGION=$2
SERVICE_NAME=$3

get_kms_status() {
    kms_ring_exist_bool=`gcloud kms keyrings describe $RESOURCE_NAME --location=$REGION --format="value(name)" > /dev/null 2>&1 ; echo $?`
    jq -n --arg kms_ring_exist_bool "$kms_ring_exist_bool" '{"kms_ring_exist_bool":$kms_ring_exist_bool}'
}

get_revison_status() {
    revision_name=`gcloud run revisions list --service=$SERVICE_NAME --region=$REGION --format="value(name)"`
    jq -n --arg revision_name "$revision_name" '{"revision_name":$revision_name}'
}

get_vpc_status() {
    vpc_exist_bool=`gcloud compute networks describe $RESOURCE_NAME --format="value(name)" > /dev/null 2>&1 ; echo $?`
    jq -n --arg vpc_exist_bool "$vpc_exist_bool" '{"vpc_exist_bool":$vpc_exist_bool}'
}

if [ "$SERVICE_NAME" = "kms" ]; then
    get_kms_status
elif [ "$SERVICE_NAME" = "cloud-run" ]; then
    get_revison_status
elif [ "$SERVICE_NAME" = "vpc" ]; then
    get_vpc_status
fi