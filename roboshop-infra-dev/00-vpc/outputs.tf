output "vpc_id" {
    value = module.vpc.vpcid
  
}

output "public_subnetids" {
    value = module.vpc.public_subnet_id
  
}

output "private_subnet_ids" {
    value = module.vpc.private_subnet_id
  
}
output "database_subnet_ids" {
    value = module.vpc.database_subnet_id
  
}
