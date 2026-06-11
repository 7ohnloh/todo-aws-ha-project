# Deployment Guide

## Required Tools

- AWS CLI with access to create VPC, EC2, ALB, ASG, RDS, S3, CloudWatch, SNS, and related resources
- Terraform 1.5 or newer
- Git
- Node.js and MySQL only if testing locally

Check installations:

```bash
aws --version
terraform version
git --version
node --version
```

## Configure AWS and Deploy

1. Configure your AWS credentials and default region:

   ```bash
   aws configure
   aws sts get-caller-identity
   ```

2. Create a local variables file:

   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Replace the example password in `terraform.tfvars`. Optionally add `alarm_email` and set `db_multi_az = true`. Do not commit this file.

4. Initialize, validate, review, and deploy:

   ```bash
   terraform init
   terraform fmt -check
   terraform validate
   terraform plan
   terraform apply
   ```

5. Get the application address:

   ```bash
   terraform output application_url
   ```

It may take several minutes for RDS and EC2 startup to finish. Open the URL after the target group shows healthy instances.

## Confirm Healthy EC2 Targets

In the AWS Console, open **EC2 > Target Groups**, choose the project target group, and open the **Targets** tab. At least two instances should show `Healthy`. The health check calls `/health` on port 3000.

Useful AWS CLI commands:

```bash
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names todo-aws-ha-asg
aws elbv2 describe-target-health --target-group-arn TARGET_GROUP_ARN
```

If targets remain unhealthy, inspect `/var/log/cloud-init-output.log` and `systemctl status todo-app` using EC2 Session Manager or another approved access method. Common causes are an incorrect database password, failed package installation, or a repository that is not publicly cloneable.

## Destroy After Testing

```bash
cd terraform
terraform destroy
```

Review the destroy plan and type `yes`. Confirm in AWS that billable resources have been removed.
