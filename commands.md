# Useful Commands

## Local Application

```bash
mysql -u root -p < database/init.sql
cd app
cp .env.example .env
npm install
npm start
```

## Git

```bash
git status
git add .
git commit -m "Build AWS high availability to-do final project"
git push origin main
```

## Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output application_url
terraform destroy
```

## AWS Checks

```bash
aws sts get-caller-identity
aws ec2 describe-instances --filters "Name=tag:Project,Values=todo-aws-ha"
aws s3 ls
```

## Benchmark

```bash
ab -n 100 -c 10 http://ALB_DNS/
curl -s -o /dev/null -w "HTTP %{http_code} in %{time_total}s\n" http://ALB_DNS/
```
