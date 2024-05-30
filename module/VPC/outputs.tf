output "tf_vpc" {
  value = aws_vpc.tf_vpc.id
}
output "tf_public_subnet_us_east_1a" {
  value = aws_subnet.tf_public_subnet_us_east_1a.id
}
output "tf_public_subnet_us_east_1b" {
  value = aws_subnet.tf_public_subnet_us_east_1b.id
}
output "tf_public_subnet_us_east_1c" {
  value = aws_subnet.tf_public_subnet_us_east_1c.id
}
output "tf_private_subnet_us_east_1a" {
  value = aws_subnet.tf_private_subnet_us_east_1a.id
}
output "tf_private_subnet_us_east_1b" {
  value = aws_subnet.tf_private_subnet_us_east_1b.id
}
output "tf_private_subnet_us_east_1c" {
  value = aws_subnet.tf_private_subnet_us_east_1c.id
}
output "tf_sg_asg" {
  value = aws_security_group.tf_sg_asg.id
}

output "tf_sg_alb" {
  value = aws_security_group.tf_sg_asg.id
}

output "tf_sg_rds" {
  value = aws_security_group.tf_sg_rds.id
}