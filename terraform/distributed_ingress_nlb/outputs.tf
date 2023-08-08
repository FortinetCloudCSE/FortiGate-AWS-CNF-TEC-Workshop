output "vpc_id" {
  value       = module.vpc-main.vpc_id
  description = "The VPC Id of the newly created VPC."
}

output "public_subnet_id_az1" {
  value       = module.subnet-public-az1.id
  description = "The Public Subnet ID for spoke vpc"
}

output "fwaas_subnet_id_az1" {
  value       = module.subnet-fwaas-az1.id
  description = "The fwaas Subnet ID in az1 vpc"
}
output "private_subnet_id_az1" {
  value       = module.subnet-private-az1.id
  description = "The Private Subnet ID for spoke vpc"
}

output "public_subnet_id_az2" {
  value       = module.subnet-public-az2.id
  description = "The Public Subnet ID for spoke vpc"
}

output "fwaas_subnet_id_az2" {
  value       = module.subnet-fwaas-az2.id
  description = "The Private Subnet ID for app vpc"
}
output "private_subnet_id_az2" {
  value       = module.subnet-private-az2.id
  description = "The Private Subnet ID for app vpc"
}
output "public_nlb_id" {
  value       = aws_lb.public_nlb_az1.id
  description = "The NLB id"
}
output "public_nlb_dns_name" {
  value       = aws_lb.public_nlb_az1.dns_name
  description = "The DNS Name of the public NLB"
}
output "nlb_web_url" {
  value = "nlb web url: http://${aws_lb.public_nlb_az1.dns_name}"
}
output "az1_web_url" {
  value = "linux az1 web url: http://${element(module.linux-instance-az1.public_eip, 0)}"
  precondition {
    condition = var.enable_public_ips
    error_message = "No public login url available"
  }
}
output "az2_web_url" {
  value = "linux az2 web url: http://${element(module.linux-instance-az2.public_eip, 0)}"
  precondition {
    condition = var.enable_public_ips
    error_message = "No public login url available"
  }
}
output "az1_ssh" {
  value = "linux az1 ssh: ssh -i ${var.keypair}.pem ubuntu@${element(module.linux-instance-az1.public_eip, 0)}"
  precondition {
    condition = var.enable_public_ips
    error_message = "No public ssh IP"
  }
}
output "az2_ssh" {
  value = "linux az2 ssh: ssh -i ${var.keypair}.pem ubuntu@${element(module.linux-instance-az2.public_eip, 0)}"
  precondition {
    condition = var.enable_public_ips
    error_message = "No public ssh IP"
  }
}