output "KKE_vpc_name" {
  value = aws_vpc.private_vpc.tags["Name"]
}

output "KKE_subnet_name" {
  value = aws_subnet.private_subnet.tags["Name"]
}

output "KKE_ec2_private" {
  value = aws_instance.private_ec2.tags["Name"]
}