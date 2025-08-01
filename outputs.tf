output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}
output "cidr_block" {
  value = aws_vpc.this.cidr_block
}
output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
