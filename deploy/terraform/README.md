
# ERS Deployment


## Setup

### Terraform
To deploy the _*message queues*_ and its associated _*policies*_ into a specific region use the terraform cli. The version of terraform used for testing deployment :
```
Terraform v0.11.7
+ provider.aws v1.30.0
```

Either install this version of terraform locally or follow the instructions below detailing how to use the terraform docker to run a deployment.

### AWS
To deploy into AWS use one of the following AWS environments.
NOTE: Session tokens is the preferred mechanism for AWS deployment and in the future will be the only one supported.

#### Session tokens
Use the Okta awscli to generate an AWS STS. Follow the instructions here to do this:
[https://github.com/Forcepoint/cpt-tools/tree/master/okta]

Make sure the following environment variable is set in your shell:
```
AWS_DEFAULT_REGION=<AWS REGION>
```


#### IAM user
NOTE: This mechanism for AWS deployment will not be supported in the future!

Make sure the following environment variables are set in your shell:
```
AWS_SECRET_ACCESS_KEY=<AWS IAM USER SECRET ACCESS KEY>
AWS_DEFAULT_REGION=<AWS REGION>
AWS_ACCESS_KEY_ID=<AWS IAM USER ACCESS KEY ID>
```


## Run

It is possible to deploy using a local terraform state. We have also added support to use terraform workspaces if that is required.

### Terraform Workspace
A terraform workspace is a named terraform state that is held remotely. You can create new ones, select already existing ones to use or delete old workspaces as you need.

```
terraform workspace new <WORKSPACE NAME>
terraform workspace select <WORKSPACE NAME>
terraform workspace delete <WORKSPACE NAME>
```

The terraform workspace state is being held in manually created S3 bucket here:
```
Region: eu-west-1
S3 Bucket: s3-cpt-d-ers-terraform-state
Dynamo Table: cpt-d-ers-terraform-state-lock
```

NOTE: In the future this may be amalgamated into a Polaris wide terraform state.

### Deploy

Deployment by default will deploy into Ohio (us-east-2). But it is possible to override this default to deploy into another region. Use the terraform variable `-var 'aws_region=us-east-1'` to deploy into a another region.

```
terraform init
terraform apply
```
or
```
terraform init
terraform apply -var 'aws_region=us-east-1'
```


Note:
At the moment we only support deployment into us-east-2 (default) or us-east-1.


## Test

To test the deployed message queues and associated policies, follow the instructions here:
[https://confluence.websense.com/display/CPT/Policy+Distribution+Service+%28PDS%29+Queue+Information]


## Using the Terraform Docker
It is possible to run the deployment using the supplied terraform docker if its not possible/desirable to install terraform locally. The following instructions show how to use the terraform docker to deploy.

### Create the .env file to use IAM user
```
AWS_SECRET_ACCESS_KEY=<>
AWS_DEFAULT_REGION=us-east-1
AWS_ACCESS_KEY_ID=<>
```