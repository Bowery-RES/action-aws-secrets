# Action AWS Secrets

Action to retrieve AWS secrets and Parameter Store values.

# Usage

```yml
env:
  DEPLOYMENT_ENVIRONMENT: development
jobs:
  ecs-deploy:
    runs-on: ubuntu-latest
    name: Read env secrets
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: aws-actions/configure-aws-credentials@v1
        with:
          role-to-assume: # role arn
          aws-region: "us-east-1"

      - name: Read secrets from AWS Secrets Manager into environment variables
        uses: Bowery-RES/action-aws-secrets@main
        with:
          secrets: |
            Github/Terraform/Development/Secret_Value,
            Github/Terraform/Development/JSon # {test: "value"}
          parameters: |
            /Github/Terraform/${{env.DEPLOYMENT_ENVIRONMENT}}/Key1,
            /Github/Terraform/${{ env.DEPLOYMENT_ENVIRONMENT }}/Key2,
            /Github/Terraform/${{ env.DEPLOYMENT_ENVIRONMENT }}/Next_KEY
```

An example above will extend env to the following enironment variables

```sh
GITHUB_TERRAFORM_DEVELOPMENT_SECRET_VALUE=***
GITHUB_TERRAFORM_DEVELOPMENT_JSON_TEST=*** # a double underscore to get json nested value
GITHUB_TERRAFORM_DEVELOPMENT_KEY1=***
GITHUB_TERRAFORM_DEVELOPMENT_KEY2=***
GITHUB_TERRAFORM_DEVELOPMENT_NEXT_KEY=***
```

If you add `namespace: false` it will add the following env vars

```sh
TEST=*** # a double underscore to get json nested value
KEY1=***
KEY2=***
NEXT_KEY=***
```

# AWS Role

Role which is used in `aws-actions/configure-aws-credentials@v1` should be created with the following Trust Relationship

```json
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<org name>/<repo name>:*"
        }
      }
    }
  ]
}
```

# Permissions

Please note, to use role based approach to configure AWS, we should add the following permissions to the job

```yml
permissions:
  id-token: write
  contents: read
```
