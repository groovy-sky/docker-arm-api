#!/bin/sh

TOKEN=$(curl -X POST -d "grant_type=client_credentials&client_id=$APP_ID&client_secret=$APP_KEY&resource=https%3A%2F%2Fmanagement.azure.com%2F" https://login.microsoftonline.com/$TENANT_ID/oauth2/token | jq -r '.access_token')

if [ $METHOD == 'ARM' ]
then
 export TIME_STAMP=$(date "+%F")
 result=$(curl -X PUT -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "{ 'properties': { 'templateLink': { 'uri': "\"$TEMPLATE_URI\"" }, 'parametersLink': {'uri': "\"$PARAMETERS_URI\""}, 'mode': 'Incremental'}}" https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.Resources/deployments/$TIME_STAMP?api-version=2019-10-01)
fi

if [ $METHOD == 'POST' ]
then
 result=$(curl -X $METHOD -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.$RESOURCE_TYPE/$RESOURCE_NAME?api-version=$RESOURCE_API)
fi

echo $result | jq '.'