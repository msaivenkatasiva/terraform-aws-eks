module "db" {
    source = "../../terraform-aws-security_group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for DB Mysql Instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "db"
}

module "ingress" {
    source = "../../terraform-aws-security_group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for Ingress Controller"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "ingress"
}

module "cluster" {
    source = "../../terraform-aws-security_group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for EKS Control Plane"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "cluster"
}

module "node" {
    source = "../../terraform-aws-security_group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for EKS Nodes"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "eks-nodes"
}

module "bastion" {
    source = "../../terraform-aws-security_group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for Bastion"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "bastion"
}

module "vpn" {
    source = "../../terraform-aws-security_group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for vpn"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "vpn"
}


