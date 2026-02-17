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

resource "aws_security_group_rule" "bastion_public" {
    type = "ingress"
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion.sg_id
}

resource "aws_security_group_rule" "cluster_bastion" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    source_security_group_id = module.bastion.sg_id
    security_group_id = module.cluster.sg_id
}

resource "aws_security_group_rule" "cluster_node" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1" 
    source_security_group_id = module.node.sg_id
    security_group_id = module.cluster.sg_id
}

resource "aws_security_group_rule" "node_cluster" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    source_security_group_id = module.cluster.sg_id
    security_group_id = module.node.sg_id
}

resource "aws_security_group_rule" "node_vpc" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/16"]
    security_group_id = module.node.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "TCP"
    source_security_group_id = module.bastion.sg_id
    security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_node" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "TCP"
    source_security_group_id = module.node.sg_id
    security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "ingress_public_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.ingress.sg_id
}

resource "aws_security_group_rule" "ingress_public_http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.ingress.sg_id
}

resource "aws_security_group_rule" "node_ingress"{
    type = "ingress"
    from_port = 30000
    to_port = 32768
    protocol = "TCP"
    source_security_group_id = module.ingress.sg_id
    security_group_id = module.node.sg_id
}