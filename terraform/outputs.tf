output "application_url" {
  description = "Open this URL after the target group reports healthy instances."
  value       = "http://${aws_lb.app.dns_name}"
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = aws_lb.app.dns_name
}

output "rds_endpoint" {
  description = "RDS endpoint used by the EC2 application instances."
  value       = aws_db_instance.main.endpoint
}

output "assets_bucket_name" {
  description = "Private S3 bucket for screenshots or project assets."
  value       = aws_s3_bucket.assets.bucket
}
