
locals {
    common_tags = {
    Environment = var.env
  }
}
provider "aws" {
  region     = var.aws_region
  default_tags {
    tags = local.common_tags
  }
}

locals {
  availability_zone_1 = "${var.aws_region}${var.availability_zone_1}"
}

locals {
  availability_zone_2 = "${var.aws_region}${var.availability_zone_2}"
}
locals {
  public_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr, var.subnet_bits, var.public_subnet_index)
}
locals {
  public_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr, var.subnet_bits, var.public_subnet_index + 3)
}
locals {
  fwaas_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr, var.subnet_bits, var.fwaas_subnet_index)
}
locals {
  fwaas_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr, var.subnet_bits, var.fwaas_subnet_index + 3)
}
locals {
  private_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr, var.subnet_bits, var.private_subnet_index)
}
locals {
  private_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr, var.subnet_bits, var.private_subnet_index + 3)
}
locals {
  linux_spoke_az1_address = cidrhost(local.private_subnet_cidr_az1, var.linux_host_ip)
}
locals {
  linux_spoke_az2_address = cidrhost(local.private_subnet_cidr_az2, var.linux_host_ip)
}
resource "random_string" "random" {
  length           = 5
  special          = false
}

#
# Spoke VPC
#
module "vpc-main" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_vpc"
  vpc_name                   = "${var.cp}-${var.env}-${var.vpc_name}-vpc"
  vpc_cidr                   = var.vpc_cidr
}

module "vpc-igw" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_igw"
  igw_name                   = "${var.cp}-${var.env}-${var.vpc_name}-igw"
  vpc_id                     = module.vpc-main.vpc_id
}

module "igw-route-table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.cp}-${var.env}-igw-rt"

  vpc_id                     = module.vpc-main.vpc_id
}
resource "aws_route_table_association" "b" {
  gateway_id     = module.vpc-igw.igw_id
  route_table_id = module.igw-route-table.id
}

#
# AZ 1
#
module "subnet-public-az1" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.cp}-${var.env}-${var.vpc_name}-public-az1"

  vpc_id                     = module.vpc-main.vpc_id
  availability_zone          = local.availability_zone_1
  subnet_cidr                = local.public_subnet_cidr_az1
}
resource aws_ec2_tag "subnet_public_tag_az1" {
  resource_id = module.subnet-public-az1.id
  key = "Workshop-area"
  value = "Public-Az1"
}

module "subnet-fwaas-az1" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.cp}-${var.env}-${var.vpc_name}-fwaas-az1"

  vpc_id                     = module.vpc-main.vpc_id
  availability_zone          = local.availability_zone_1
  subnet_cidr                = local.fwaas_subnet_cidr_az1
}

resource aws_ec2_tag "subnet_fwaas_tag_az1" {
  resource_id = module.subnet-fwaas-az1.id
  key = "Workshop-area"
  value = "Fwaas-Az1"
}

module "subnet-private-az1" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.cp}-${var.env}-${var.vpc_name}-private-az1"

  vpc_id                     = module.vpc-main.vpc_id
  availability_zone          = local.availability_zone_1
  subnet_cidr                = local.private_subnet_cidr_az1
}
resource aws_ec2_tag "subnet_private_tag_az1" {
  resource_id = module.subnet-private-az1.id
  key = "Workshop-area"
  value = "Private-Az1"
}
module "private-route-table-az1" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.cp}-${var.env}-private-rt-az1"

  vpc_id                     = module.vpc-main.vpc_id
}
module "private-route-table-association-az1" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  subnet_ids                 = module.subnet-private-az1.id
  route_table_id             = module.private-route-table-az1.id
}
module "fwaas-route-table-az1" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.cp}-${var.env}-fwaas-rt-az1"

  vpc_id                     = module.vpc-main.vpc_id
}
module "fwaas-route-table-association-az1" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  subnet_ids                 = module.subnet-fwaas-az1.id
  route_table_id             = module.fwaas-route-table-az1.id
}

#
# AZ 2
#
module "subnet-public-az2" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.cp}-${var.env}-${var.vpc_name}-public-az2"

  vpc_id                     = module.vpc-main.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.public_subnet_cidr_az2
}
resource aws_ec2_tag "subnet_public_tag_az2" {
  resource_id = module.subnet-public-az2.id
  key = "Workshop-area"
  value = "Public-Az2"
}
module "subnet-fwaas-az2" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.cp}-${var.env}-${var.vpc_name}-fwaas-az2"

  vpc_id                     = module.vpc-main.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.fwaas_subnet_cidr_az2
}
resource aws_ec2_tag "subnet_fwaas_tag_az2" {
  resource_id = module.subnet-fwaas-az2.id
  key = "Workshop-area"
  value = "Fwaas-Az2"
}
resource aws_ec2_tag "fwaas_tag_az1" {
  resource_id = module.subnet-fwaas-az1.id
  key = "fortigatecnf_subnet_type"
  value = "endpoint"
}
resource aws_ec2_tag "fwaas_tag_az2" {
  resource_id = module.subnet-fwaas-az2.id
  key = "fortigatecnf_subnet_type"
  value = "endpoint"
}
module "subnet-private-az2" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name                = "${var.cp}-${var.env}-${var.vpc_name}-private-az2"

  vpc_id                     = module.vpc-main.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.private_subnet_cidr_az2
}
resource aws_ec2_tag "subnet_private_tag_az2" {
  resource_id = module.subnet-private-az2.id
  key = "Workshop-area"
  value = "Private-Az2"
}
module "public-route-table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.cp}-${var.env}-public-rt"

  vpc_id                     = module.vpc-main.vpc_id
}

module "public_route_table_association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  subnet_ids                 = module.subnet-public-az2.id
  route_table_id             = module.public-route-table.id
}

module "private-route-table-az2" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.cp}-${var.env}-private-rt-az2"

  vpc_id                     = module.vpc-main.vpc_id
}
module "private-route-table-association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  subnet_ids                 = module.subnet-private-az2.id
  route_table_id             = module.private-route-table-az2.id
}
module "fwaas-route-table-az2" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.cp}-${var.env}-fwaas-rt-az2"

  vpc_id                     = module.vpc-main.vpc_id
}
module "fwaas-route-table-association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  subnet_ids                 = module.subnet-fwaas-az2.id
  route_table_id             = module.fwaas-route-table-az2.id
}

module "public-route-table-association-az1" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  subnet_ids                 = module.subnet-public-az1.id
  route_table_id             = module.public-route-table.id
}

module "public-route-table-association-az2" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  subnet_ids                 = module.subnet-public-az2.id
  route_table_id             = module.public-route-table.id
}

#
# Default route table that is created with the main VPC.
#
resource "aws_default_route_table" "route_spoke" {
  default_route_table_id = module.vpc-main.vpc_main_route_table_id
  tags = {
    Name = "default table for vpc main (unused)"
  }
}

#
# Point the private route table default route to the Fortigate Private ENI
#
resource "aws_route" "public-default-route" {
  route_table_id         = module.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
resource "aws_route" "private-az1-default-route" {
  route_table_id         = module.private-route-table-az1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
resource "aws_route" "private-az2-default-route" {
  route_table_id         = module.private-route-table-az2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
resource "aws_route" "fwaas-az1-default-route" {
  route_table_id         = module.fwaas-route-table-az1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
resource "aws_route" "fwaas-az2-default-route" {
  route_table_id         = module.fwaas-route-table-az2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc-igw.igw_id
}
#
# NLB used for termination of Private Link from Endpoint. Listeners and port 22 and 80
# Target group is the Linux instances above.
#
resource "aws_eip" "nlb_eip" {
  count                 = 2
  domain                = "vpc"
}

resource "aws_lb" "public_nlb_az1" {
  name = "${var.cp}-${var.env}-${var.vpc_name}-fwaas-az2"
  internal = false
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = false
  subnet_mapping {
    subnet_id     = module.subnet-public-az1.id
    allocation_id = aws_eip.nlb_eip[0].id
  }
  subnet_mapping {
    subnet_id     = module.subnet-public-az2.id
    allocation_id = aws_eip.nlb_eip[1].id
  }
  tags = {
    Name = "Workshop NLB"
  }
}

resource "aws_lb_listener" "nlb_listener_http" {
  load_balancer_arn = aws_lb.public_nlb_az1.arn
  port = "80"
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.private_nlb_target_group_http.arn
  }
}

resource "aws_lb_listener" "nlb_listener_ssh" {
  load_balancer_arn = aws_lb.public_nlb_az1.arn
  port = "22"
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.private_nlb_target_group_ssh.arn
  }
}


resource "aws_lb_target_group" "private_nlb_target_group_http" {
  name      = "internal-http"
  port      = 80
  protocol  = "TCP"
  vpc_id    = module.vpc-main.vpc_id
}

resource "aws_lb_target_group" "private_nlb_target_group_ssh" {
  name      = "internal-ssh"
  port      = 22
  protocol  = "TCP"
  vpc_id    = module.vpc-main.vpc_id
}

resource "aws_lb_target_group_attachment" "nlb_target_az1_group_att_ssh" {
  target_group_arn = aws_lb_target_group.private_nlb_target_group_ssh.arn
  target_id = module.linux-instance-az1.instance_id
}

resource "aws_lb_target_group_attachment" "nlb_target_az1_group_att_http" {
  target_group_arn = aws_lb_target_group.private_nlb_target_group_http.arn
  target_id = module.linux-instance-az1.instance_id
}
resource "aws_lb_target_group_attachment" "nlb_target_az2_group_att_ssh" {
  target_group_arn = aws_lb_target_group.private_nlb_target_group_ssh.arn
  target_id = module.linux-instance-az2.instance_id
}

resource "aws_lb_target_group_attachment" "nlb_target_az2_group_att_http" {
  target_group_arn = aws_lb_target_group.private_nlb_target_group_http.arn
  target_id = module.linux-instance-az2.instance_id
}

#
# Linux Instances from here down
#
# Linux Instance that are added to each AZ in the private subnet
#
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

resource "aws_security_group" "ec2-sg" {
  name = "${var.cp}-${var.env}-${random_string.random.result}-${var.ec2_sg_name} Security Group"
  description = "Security Group for Linux Instances"
  vpc_id = module.vpc-main.vpc_id
  ingress {
    description = "Allow SSH from Anywhere IPv4 (change this to My IP)"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "Allow SSH from NLB"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ local.public_subnet_cidr_az1, local.public_subnet_cidr_az2 ]
  }
  ingress {
    description = "Allow HTTP from Anywhere IPv4 (Change this to My IP)"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "Allow HTTP from Load Balancer"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ local.public_subnet_cidr_az1, local.public_subnet_cidr_az2 ]
  }
  ingress {
    description = "Allow Syslog from anywhere IPv4"
    from_port = 514
    to_port = 514
    protocol = "udp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "Allow ICMP Echo from anywhere IPv4 (Change this to My IP)"
    from_port = 8
    to_port = 0
    protocol = "icmp"
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

#
# IAM Profile for linux instance
#
module "linux-iam-profile" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance_iam_role"
  iam_role_name = "${var.cp}-${var.env}-${random_string.random.result}-linux-instance_role"
}

#
# AZ1 Linux Instance
#
module "linux-instance-az1" {
  source                      = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  depends_on                  = [module.vpc-igw]
  aws_ec2_instance_name       = "${var.cp}-${var.env}-${var.vpc_name}-${var.linux_instance_name}-az1"
  enable_public_ips           = true
  availability_zone           = local.availability_zone_1
  public_subnet_id            = module.subnet-private-az1.id
  public_ip_address           = local.linux_spoke_az1_address
  aws_ami                     = data.aws_ami.ubuntu.id
  keypair                     = var.keypair
  instance_type               = var.linux_instance_type
  security_group_public_id    = aws_security_group.ec2-sg.id
  acl                         = var.acl
  iam_instance_profile_id     = module.linux-iam-profile.id
  userdata_rendered           = data.template_file.web_userdata_az1.rendered
}

resource aws_ec2_tag "linux_instance_tag_az1" {
  resource_id = module.linux-instance-az1.instance_id
  key = "Workshop-Function"
  value = "ApacheServer"
}

#
# AZ2 Linux Instance
#
module "linux-instance-az2" {
  source                      = "git::https://github.com/40netse/terraform-modules.git//aws_ec2_instance"
  depends_on                  = [module.vpc-igw]
  aws_ec2_instance_name       = "${var.cp}-${var.env}-${var.vpc_name}-${var.linux_instance_name}-az2"
  enable_public_ips           = true
  availability_zone           = local.availability_zone_2
  public_subnet_id            = module.subnet-private-az2.id
  public_ip_address           = local.linux_spoke_az2_address
  aws_ami                     = data.aws_ami.ubuntu.id
  keypair                     = var.keypair
  instance_type               = var.linux_instance_type
  security_group_public_id    = aws_security_group.ec2-sg.id
  acl                         = var.acl
  iam_instance_profile_id     = module.linux-iam-profile.id
  userdata_rendered           = data.template_file.web_userdata_az2.rendered
}

resource aws_ec2_tag "linux_instance_tag_az2" {
  resource_id = module.linux-instance-az2.instance_id
  key = "Workshop-Function"
  value = "ApacheServer"
}
