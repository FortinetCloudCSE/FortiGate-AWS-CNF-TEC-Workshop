
locals {
  linux_inspection_az1_public_ip_address = cidrhost(local.public_subnet_cidr_az1, var.linux_host_ip)
}
locals {
  linux_east_az1_ip_address = cidrhost(var.vpc_cidr_east_private_az1, var.linux_host_ip)
}
locals {
  linux_east_az2_ip_address = cidrhost(var.vpc_cidr_east_private_az2, var.linux_host_ip)
}
locals {
  linux_west_az1_ip_address = cidrhost(var.vpc_cidr_west_private_az1, var.linux_host_ip)
}
locals {
  linux_west_az2_ip_address = cidrhost(var.vpc_cidr_west_private_az2, var.linux_host_ip)
}
locals {
  fortimanager_ip_address = cidrhost(local.public_subnet_cidr_az1, var.fortimanager_host_ip)
}
locals {
  fortianalyzer_ip_address = cidrhost(local.public_subnet_cidr_az1, var.fortianalyzer_host_ip)
}

resource "null_resource" "previous" {}

resource "time_sleep" "wait_5_minutes" {
  depends_on = [ module.inspection_instance_jump_box ]

  create_duration = "5m"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_5_minutes]
}

#
# Optional Linux Instances from here down
#
# Linux Instance that are added on to the East and West VPCs for testing EAST->West Traffic
#
# Endpoint AMI to use for Linux Instances. Just added this on the end, since traffic generating linux instances
# would not make it to a production template.
#
data "template_file" "web_userdata_az1" {
  template = file("./config_templates/web-userdata.tpl")
  vars = {
    region                = var.aws_region
    availability_zone     = var.availability_zone_1
  }
}
data "template_file" "web_userdata_az2" {
  template = file("./config_templates/web-userdata.tpl")
  vars = {
    region                = var.aws_region
    availability_zone     = var.availability_zone_2
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220609"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

#
# EC2 Endpoint Resources
#

#
# Security Groups are VPC specific, so an "ALLOW ALL" for each VPC
#

resource "aws_security_group" "ec2-jump-box-sg" {
  description = "Security Group for Linux Jump Box"
  vpc_id = module.vpc-inspection.vpc_id
  ingress {
    description = "Allow SSH from Anywhere IPv4 (change this to My IP)"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "Allow Syslog from anywhere IPv4"
    from_port = 514
    to_port = 514
    protocol = "udp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    description = "Allow egress ALL"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

module "ec2-inspection-sg" {
  source                  = "git::https://github.com/40netse/terraform-modules.git//aws_security_group"
  sg_name                 = "${var.cp}-${var.env}-${random_string.random.result}-east sg Allow Inspection Subnets"
  vpc_id                  = module.vpc-inspection.vpc_id
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = "0.0.0.0/0"
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access  = "0.0.0.0/0"
}

module "ec2-east-sg" {
  source                  = "git::https://github.com/40netse/terraform-modules.git//aws_security_group"
  sg_name                 = "${var.cp}-${var.env}-${random_string.random.result}-east sg Allow East Subnets"
  vpc_id                  = module.vpc-east.vpc_id
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = "0.0.0.0/0"
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access  = "0.0.0.0/0"
}


module "ec2-west-sg" {
  source                  = "git::https://github.com/40netse/terraform-modules.git//aws_security_group"
  sg_name                 = "${var.cp}-${var.env}-${random_string.random.result}-west sg Allow West Subnets"
  vpc_id                  = module.vpc-west.vpc_id
  ingress_to_port         = 0
  ingress_from_port       = 0
  ingress_protocol        = "-1"
  ingress_cidr_for_access = "0.0.0.0/0"
  egress_to_port          = 0
  egress_from_port        = 0
  egress_protocol         = "-1"
  egress_cidr_for_access  = "0.0.0.0/0"
}

#
# IAM Profile for linux instance
#
module "linux_iam_profile" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance_iam_role"
  iam_role_name = "${var.cp}-${var.env}-${random_string.random.result}-linux-instance_role"
}

#
# East Linux Instance for Jump Box
#
module "inspection_instance_jump_box" {
  source                      = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  aws_ec2_instance_name       = "${var.cp}-${var.env}-inspection-jump-box-instance"
  enable_public_ips           = true
  availability_zone           = local.availability_zone_1
  public_subnet_id            = module.subnet-inspection-public-az1.id
  public_ip_address           = local.linux_inspection_az1_public_ip_address
  aws_ami                     = data.aws_ami.ubuntu.id
  keypair                     = var.keypair
  instance_type               = var.linux_instance_type
  security_group_public_id    = aws_security_group.ec2-jump-box-sg.id
  acl                         = var.acl
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = data.template_file.web_userdata_az1.rendered
}

#
# East Linux Instance for Generating East->West Traffic
#

module "east_instance_private_az1" {
  source                      = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  aws_ec2_instance_name       = "${var.cp}-${var.env}-east-private-az1-instance"
  enable_public_ips           = false
  availability_zone           = local.availability_zone_1
  public_subnet_id            = module.subnet-east-private-az1.id
  public_ip_address           = local.linux_east_az1_ip_address
  aws_ami                     = data.aws_ami.ubuntu.id
  keypair                     = var.keypair
  instance_type               = var.linux_instance_type
  security_group_public_id    = module.ec2-east-sg.id
  acl                         = var.acl
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = data.template_file.web_userdata_az1.rendered
}

module "east_instance_private_az2" {
  source                      = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  aws_ec2_instance_name       = "${var.cp}-${var.env}-east-private-az2-instance"
  enable_public_ips           = false
  availability_zone           = local.availability_zone_2
  public_subnet_id            = module.subnet-east-private-az2.id
  public_ip_address           = local.linux_east_az2_ip_address
  aws_ami                     = data.aws_ami.ubuntu.id
  keypair                     = var.keypair
  instance_type               = var.linux_instance_type
  security_group_public_id    = module.ec2-east-sg.id
  acl                         = var.acl
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = data.template_file.web_userdata_az2.rendered
}

#
# West Linux Instance for Generating West->East Traffic
#
module "west_instance_private_az1" {
  source                      = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  aws_ec2_instance_name       = "${var.cp}-${var.env}-west-private-az1-instance"
  enable_public_ips           = false
  availability_zone           = local.availability_zone_1
  public_subnet_id            = module.subnet-west-private-az1.id
  public_ip_address           = local.linux_west_az1_ip_address
  aws_ami                     = data.aws_ami.ubuntu.id
  keypair                     = var.keypair
  instance_type               = var.linux_instance_type
  security_group_public_id    = module.ec2-west-sg.id
  acl                         = var.acl
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = data.template_file.web_userdata_az1.rendered
}

module "west_instance_private_az2" {
  depends_on                  = [ module.vpc-transit-gateway-attachment-west ]
  source                      = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  aws_ec2_instance_name       = "${var.cp}-${var.env}-west-private-az2-instance"
  enable_public_ips           = false
  availability_zone           = local.availability_zone_2
  public_subnet_id            = module.subnet-west-private-az2.id
  public_ip_address           = local.linux_west_az2_ip_address
  aws_ami                     = data.aws_ami.ubuntu.id
  keypair                     = var.keypair
  instance_type               = var.linux_instance_type
  security_group_public_id    = module.ec2-west-sg.id
  acl                         = var.acl
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = data.template_file.web_userdata_az2.rendered
}

#
# Fortimanager
#
data "template_file" "fmgr_userdata" {
  template = file("./config_templates/fmgr-userdata.tpl")

  vars = {
    fmgr_byol_license      = file("./licenses/fmgr-license.lic")
  }
}

#
# Fortianalyzer
#
data "template_file" "faz_userdata" {
  template = file("./config_templates/faz-userdata.tpl")

  vars = {
    faz_byol_license      = file("./licenses/faz-license.lic")
  }
}

data "aws_ami" "fortimanager" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = ["FortiManager VM64-AWS *(${var.fortimanager_os_version})*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
}

data "aws_ami" "fortianalyzer" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = ["FortiAnalyzer-VM64-AWS *(${var.fortianalyzer_os_version}) GA*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
}

module "iam_profile" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance_iam_role"
  iam_role_name               = "Fortimanager-iam_role"
}

#
# This is an "allow all" security group, but a place holder for a more strict SG
#
resource aws_security_group "fortimanager_sg" {
  name = "allow_public_subnets_fmg"
  description = "Fortimanager Allow all traffic from public Subnets"
  vpc_id = module.vpc-inspection.vpc_id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_public_subnets"
  }
}

module "fortimanager" {
  source                      = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  aws_ec2_instance_name       = "${var.cp}-${var.env}-Fortimanager"
  availability_zone           = local.availability_zone_1
  instance_type               = var.fortimanager_instance_type
  public_subnet_id            = module.subnet-inspection-public-az1.id
  public_ip_address           = local.fortimanager_ip_address
  aws_ami                     = data.aws_ami.fortimanager.id
  enable_public_ips           = true
  keypair                     = var.keypair
  security_group_public_id    = aws_security_group.fortimanager_sg.id
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = data.template_file.fmgr_userdata.rendered
}

resource aws_security_group "fortianalyzer_sg" {
  name = "allow_public_subnets_faz"
  description = "Fortianalyzer Allow all traffic from public Subnets"
  vpc_id = module.vpc-inspection.vpc_id
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_public_subnets"
  }
}


module "fortianalyzer" {
  source                      = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  aws_ec2_instance_name       = "${var.cp}-${var.env}-Fortianalyzer"
  availability_zone           = local.availability_zone_1
  instance_type               = var.fortianalyzer_instance_type
  public_subnet_id            = module.subnet-inspection-public-az1.id
  public_ip_address           = local.fortianalyzer_ip_address
  aws_ami                     = data.aws_ami.fortianalyzer.id
  enable_public_ips           = true
  keypair                     = var.keypair
  security_group_public_id    = aws_security_group.fortianalyzer_sg.id
  iam_instance_profile_id     = module.iam_profile.id
  userdata_rendered           = data.template_file.faz_userdata.rendered
}
