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
            Github/Terraform/Development/Secret_Value
          parameters: |
            /Github/Terraform/${{env.DEPLOYMENT_ENVIRONMENT}}/Key1,
            /Github/Terraform/${{ env.DEPLOYMENT_ENVIRONMENT }}/Key2,
            /Github/Terraform/${{ env.DEPLOYMENT_ENVIRONMENT }}/Next_KEY
```

An example above will extend env to the following enironment variables

```
GITHUB_TERRAFORM_DEVELOPMENT_SECRET_VALUE=***
GITHUB_TERRAFORM_DEVELOPMENT_KEY1=***
GITHUB_TERRAFORM_DEVELOPMENT_KEY2=***
GITHUB_TERRAFORM_DEVELOPMENT_NEXT_KEY=***
```
