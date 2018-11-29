## Overview
Example SAM templates for deploying Lambda functions and an API Gateway


## Pre-requisites
You will need to have an IAM role with which your Lambda function will be associated. The trust policy should be as
follows:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```
And from there you can associate whatever permissions policies that you would like. Ideally, we should allow for our
Lambda function to write to Cloudwatch logs. To do so, we need the following permissions policy.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        }
    ]
}
```

## Deployment
To deploy this example, you first need to setup an environment.sh file with the following environment variables. This
environment.sh file should be in the same directory as the deploy.sh file.

```bash
#!/bin/bash

PROFILE=your-aws-cli-profile-name
S3BUCKET=your-s3-bucket
LAMBDA_ROLE=arn:aws:iam::123456789012:role/service-role/your-iam-role
ENV1=test1
ENV2=test2
```

Once your environment variables are setup, you can run the deploy.sh script to perform the SAM package and SAM deploy
commands.

If all goes well, you will see something like the following:

```text
PROFILE=your-aws-cli-profile-name
S3BUCKET=your-s3-bucket
LAMBDA_ROLE=arn:aws:iam::123456789012:role/service-role/your-iam-role
ENV1=test1
ENV2=test2

Uploading to 4851fc9c928fd596e088dc6979927f99  886 / 886.0  (100.00%)
Successfully packaged artifacts and wrote output template to file templates/sam_output.yaml.
Execute the following command to deploy the packaged template
aws cloudformation deploy --template-file sam_example/templates/sam_output.yaml --stack-name <YOUR STACK NAME>

Deploying Lambda stack (sam-example)...

Waiting for changeset to be created..
Waiting for stack create/update to complete
Successfully created/updated stack - sam-example
export LAMBDA=arn:aws:lambda:us-east-1:123456789012:function:sam-example-ExampleLambda-1VQKAERNT1JV8
export APIURL=https://abcde12345.execute-api.us-east-1.amazonaws.com
*   Trying 11.22.33.44...
* Connected to abcde12345.execute-api.us-east-1.amazonaws.com (11.22.33.44) port 443 (#0)
* TLS 1.2 connection using TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
* Server certificate: *.execute-api.us-east-1.amazonaws.com
* Server certificate: Amazon
* Server certificate: Amazon Root CA 1
* Server certificate: Starfield Services Root Certificate Authority - G2
> GET /Prod/example HTTP/1.1
> Host: abcde12345.execute-api.us-east-1.amazonaws.com
> User-Agent: curl/7.43.0
> Accept: */*
> Content-Type: application/json
>
< HTTP/1.1 200 OK
< Content-Type: application/json
< Content-Length: 9
< Connection: keep-alive
< Date: Thu, 29 Nov 2018 23:15:05 GMT
...
<
* Connection #0 to host abcde12345.execute-api.us-east-1.amazonaws.com left intact
"success"
# ```