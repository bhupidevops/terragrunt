data "aws_region" "current_region" {} # Find region, e.g. us-east-1

data "aws_caller_identity" "this" {}

# ---------------------------------------------------------------------------------------------------------------------
# Determine cluster id from name (${var.solution_name}-cluster)
# ---------------------------------------------------------------------------------------------------------------------
data "aws_ecs_cluster" "selected" {
  cluster_name = var.container_runtime
}

# ---------------------------------------------------------------------------------------------------------------------
# Determine loadbalancer arn from ssm param store
# ---------------------------------------------------------------------------------------------------------------------
data "aws_ssm_parameter" "alb_arn" {
  name = "/${var.solution_name}/alb_arn"
}

# ---------------------------------------------------------------------------------------------------------------------
# Determine loadbalancer listener arn from ssm param store
# ---------------------------------------------------------------------------------------------------------------------
data "aws_ssm_parameter" "alb_listener_443_arn" {
  name = "/${var.solution_name}/alb_listener_443_arn"
}

# ---------------------------------------------------------------------------------------------------------------------
# Determine loadbalancer listener arn from ssm param store
# ---------------------------------------------------------------------------------------------------------------------
data "aws_ssm_parameter" "alb_listener_80_arn" {
  name = "/${var.solution_name}/alb_listener_80_arn"
}

# ---------------------------------------------------------------------------------------------------------------------
# Determine VPC id from VPC name (${var.solution_name}-vpc)
# ---------------------------------------------------------------------------------------------------------------------
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.solution_name}/vpc_id"
}

# ---------------------------------------------------------------------------------------------------------------------
# Determine private subnet ids from selected VPC
# Filters by subnet names generated by VPC module (e.g. ito-aws-private-a, ito-aws-private-b)
# ---------------------------------------------------------------------------------------------------------------------
data "aws_ssm_parameter" "private_subnets" {
  name = "/${var.solution_name}/private_subnets"
}

# ---------------------------------------------------------------------------------------------------------------------
# Determine security groups
# ---------------------------------------------------------------------------------------------------------------------
data "aws_security_group" "ecs_default_sg" {
  name = "${var.solution_name}_ecs_task_sg"
}

data "aws_security_group" "mysql_marker_sg" {
  name = "${var.solution_name}_mysql_access_marker_sg"
}

data "aws_security_group" "redis_marker_sg" {
  name = "${var.solution_name}_redis_access_marker_sg"
}

data "aws_security_group" "postgres_marker_sg" {
  name = "${var.solution_name}_postgres_access_marker_sg"
}

data "aws_ssm_parameter" "ssm_container_runtime_kms_key_id" {
  count = var.enable_ecs_exec ? 1 : 0
  name  = "/${var.solution_name}/${var.container_runtime}/container_runtime_kms_key_id"
}

# ---------------------------------------------------------------------------------------------------------------------
# Determine KMS key
# ---------------------------------------------------------------------------------------------------------------------
data "aws_kms_key" "solution_key" {
  count  = var.enable_ecs_exec ? 1 : 0
  key_id = data.aws_ssm_parameter.ssm_container_runtime_kms_key_id[0].value
}