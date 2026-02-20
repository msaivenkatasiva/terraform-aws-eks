locals {
  common_name_suffix = "${var.project_name}-${var.environment}" # roboshop-dev
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split("," , data.aws_ssm_parameter.private_subnet_ids.value)
  cluster_sg_id = data.aws_ssm_parameter.cluster_sg_id.value
  node_sg_id = data.aws_ssm_parameter.node_sg_id.value
  common_tags = {
    Project = var.project_name
    Environment = var.environment
    Terraform = "true"
  }
}