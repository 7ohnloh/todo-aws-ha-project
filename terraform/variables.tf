variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Short name used when naming AWS resources."
  type        = string
  default     = "todo-aws-ha"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type used by the Auto Scaling Group."
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum number of EC2 instances."
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of EC2 instances."
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Normal number of EC2 instances."
  type        = number
  default     = 2
}

variable "db_name" {
  description = "Name of the MySQL database."
  type        = string
  default     = "todo_app"
}

variable "db_username" {
  description = "Administrator username for RDS."
  type        = string
  default     = "todo_admin"
}

variable "db_password" {
  description = "Administrator password for RDS. Supply it through TF_VAR_db_password or terraform.tfvars."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "The database password must contain at least 8 characters."
  }
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_multi_az" {
  description = "Create a standby RDS instance in another AZ. Enable for full database high availability; it increases cost."
  type        = bool
  default     = false
}

variable "alarm_email" {
  description = "Optional email address for CloudWatch alarm notifications. Leave empty to skip SNS."
  type        = string
  default     = ""
}
