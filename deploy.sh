#!/bin/bash

source environment.sh
echo "PROFILE=$PROFILE"
echo "S3BUCKET=$S3BUCKET"
echo "LAMBDA_ROLE=$LAMBDA_ROLE"
echo "ENV1=ENV1"
echo "ENV2=ENV2"

echo
aws --profile $PROFILE cloudformation package \
--template-file templates/sam_input.yaml \
--output-template-file templates/sam_output.yaml \
--s3-bucket $S3BUCKET

STACK=sam-example

echo
echo "Deploying Lambda stack ($STACK)..."
PARAMS="ParamLambdaRoleArn=$LAMBDA_ROLE ParamEnv1=$ENV1 ParamEnv2=$ENV2"
aws --profile $PROFILE cloudformation deploy \
--template-file templates/sam_output.yaml \
--stack-name $STACK \
--parameter-overrides $PARAMS \
--capabilities CAPABILITY_NAMED_IAM

LAMBDA=$(aws --profile $PROFILE cloudformation describe-stacks --stack-name $STACK | jq --raw-output -c '.["Stacks"][]["Outputs"][]  | select(.OutputKey == "OutExampleLambdaArn") | .OutputValue') && echo "export LAMBDA=$LAMBDA"
APIURL=$(aws --profile $PROFILE cloudformation describe-stacks --stack-name $STACK | jq --raw-output -c '.["Stacks"][]["Outputs"][]  | select(.OutputKey == "OutExampleApiUrl") | .OutputValue') && echo "export APIURL=$APIURL"

curl -X "GET" -H "Content-Type: application/json" -v $APIURL/Prod/example