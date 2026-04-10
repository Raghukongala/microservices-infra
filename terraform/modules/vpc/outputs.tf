output "vpc_id" {
<<<<<<< HEAD
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
=======
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
>>>>>>> ffcac67a74213d11886f199667ede2a33d505137
}
