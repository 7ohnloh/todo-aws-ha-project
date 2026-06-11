# Monitoring

Amazon CloudWatch helps answer two operational questions: "Is the application working?" and "Does it have enough capacity?"

## Metrics to Check

- **EC2 / ASG CPUUtilization:** High average CPU may mean the application needs more instances.
- **ALB RequestCount:** Shows how much HTTP traffic reaches the load balancer.
- **ALB TargetResponseTime:** Shows how long targets take to answer.
- **ALB HealthyHostCount:** Shows how many instances can receive traffic.
- **ALB UnHealthyHostCount:** Shows failed target health checks.
- **RDS CPUUtilization, DatabaseConnections, and FreeStorageSpace:** Show database workload and capacity.

Use the CloudWatch Metrics page or the monitoring tabs for EC2, ALB, and RDS. Compare the graphs while running the commands in `benchmarking.md`.

## Alarms in This Project

Terraform creates:

- A high CPU alarm when average ASG CPU is above 70% for two five-minute periods.
- An unhealthy-host alarm when the target group reports an unhealthy target.

If `alarm_email` is provided, Terraform creates an SNS topic and email subscription. AWS sends a confirmation message; notifications do not begin until the subscription is confirmed.

CloudWatch alarms help operators detect a problem before users report it. An alarm can notify a person or trigger automation. Monitoring also provides evidence when explaining scaling behavior during a class presentation.
