# Highly Available To-Do List Web Application on AWS

This repository is a **student AWS cloud computing final project**. It demonstrates how a small Node.js application can run across multiple EC2 instances behind an Application Load Balancer, share data in Amazon RDS, scale with an Auto Scaling Group, store project assets in S3, and be monitored with CloudWatch.

Repository: https://github.com/7ohnloh/todo-aws-ha-project

## Architecture

```text
Users
  |
  v
Application Load Balancer (port 80, two Availability Zones)
  |
  v
EC2 Auto Scaling Group (at least two instances, app on port 3000)
  |
  v
Amazon RDS for MySQL

S3 stores private project assets. CloudWatch monitors the ASG and ALB targets.
```

The ALB sends requests only to healthy EC2 targets. The ASG keeps at least two application instances running across two Availability Zones. Every instance uses the same RDS database, so tasks remain consistent when traffic moves between instances. For a lower-cost classroom deployment, RDS Multi-AZ is off by default; set `db_multi_az = true` to demonstrate database failover too.

## AWS Services Used

- **VPC and subnets:** isolated project network spanning two Availability Zones
- **EC2 Launch Template and Auto Scaling Group:** repeatable application servers and automatic replacement/scaling
- **Application Load Balancer:** distributes HTTP requests and performs health checks
- **RDS MySQL:** shared persistent task storage
- **S3:** private bucket for screenshots or project assets
- **CloudWatch and optional SNS:** CPU and unhealthy-host alarms
- **Terraform:** Infrastructure as Code for all AWS resources

## Application Features

- View, add, edit, delete, complete, and reopen tasks
- Responsive EJS interface
- MySQL queries with parameterized values
- Database connection configured only through environment variables
- `/health` endpoint for ALB target health checks
- Automatic creation of the `tasks` table on startup

## Run Locally

Requirements: Node.js, npm, and a running MySQL server.

```bash
mysql -u root -p < database/init.sql
cd app
cp .env.example .env
# Edit .env with your local MySQL details.
npm install
npm start
```

Open http://localhost:3000. Never commit the `.env` file.

## Deploy with Terraform

Configure AWS CLI credentials, then prepare the Terraform variables:

```bash
aws configure
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars and replace the example database password.
terraform init
terraform validate
terraform plan
terraform apply
terraform output application_url
```

Wait several minutes after `terraform apply` for EC2 user data to install Node.js and start the service. Then open the `application_url` output. See [docs/deployment-guide.md](docs/deployment-guide.md) for verification and troubleshooting.

## Destroy Resources

AWS resources incur charges while they exist. After the demonstration:

```bash
cd terraform
terraform destroy
```

Confirm in the AWS console that the RDS instance, load balancer, EC2 instances, and other project resources are gone.

## Security and Cost Notes

- Passwords are not stored in application code or Git. `terraform.tfvars`, state files, and `.env` are ignored.
- Terraform state still contains sensitive values. Keep it private and use an encrypted remote backend in a production project.
- The ALB is the only component open to internet HTTP traffic. EC2 port 3000 accepts traffic only from the ALB; RDS accepts MySQL only from the EC2 security group.
- RDS is not publicly accessible and the S3 bucket blocks public access.
- This classroom design uses public EC2 subnets to avoid NAT Gateway cost. A production design would normally use private app and database subnets, HTTPS, Secrets Manager, restricted IAM roles, and deletion protection.
- `t3.micro` and `db.t3.micro` may be inexpensive or free-tier eligible depending on the AWS account, but ALB, RDS, EC2, S3, and data transfer can still create charges.

## Ethical AI Disclosure

AI tools were used to help generate and organize portions of the code and documentation. The student is responsible for reviewing, modifying, testing, and understanding the project. Generated material should be adapted and checked by the student, and the project is intended only for academic learning. See [docs/ethical-use-ai.md](docs/ethical-use-ai.md).

## Documentation

- [Architecture explanation](docs/architecture.md)
- [Deployment guide](docs/deployment-guide.md)
- [Benchmarking guide](docs/benchmarking.md)
- [Monitoring guide](docs/monitoring.md)
- [Useful commands](commands.md)
