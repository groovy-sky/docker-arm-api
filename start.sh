#!/bin/sh

TOKEN=$(curl -X POST -d "grant_type=client_credentials&client_id=$APP_ID&client_secret=$APP_KEY&resource=https%3A%2F%2Fmanagement.azure.com%2F" https://login.microsoftonline.com/$TENANT_ID/oauth2/token | jq -r '.access_token')

if [ "$METHOD" = "POST" ]; then
 BODY='Content-Length: 0'
fi

if [ "$METHOD" = "ARM" ]; then
 BODY="{'properties':{'templateLink':{'uri':'$TEMPLATE_URI'},'parametersLink':{'uri':'$PARAMETERS_URI'},'mode':'Incremental'}}"
 METHOD='PUT'
 RESOURCE_NAME=$(date "+%F")
fi

if [ "$METHOD" = "PUT" ] || [ "$METHOD" = "POST" ]; then
 result=$(curl -X $METHOD -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d $BODY https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.$RESOURCE_TYPE/$RESOURCE_NAME$APPEND_PARAM?api-version=$RESOURCE_API)
fi

if [ "$METHOD" = "GET" ] || [ "$METHOD" = "DELETE" ]; then
 result=$(curl -X $METHOD -H "Authorization: Bearer $TOKEN" https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.$RESOURCE_TYPE/$RESOURCE_NAME$APPEND_PARAM?api-version=$RESOURCE_API)
fi

echo $result | jq -r '.'