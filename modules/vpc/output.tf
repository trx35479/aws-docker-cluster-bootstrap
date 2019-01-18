# output the subnet's

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnets" {
  value = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}", "${aws_subnet.main-public-3.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.main-private-1.id}", "${aws_subnet.main-private-2.id}", "${aws_subnet.main-private-3.id}"]
}

output "security_groups" {
  value = ["${aws_security_group.internal-secg.id}", "${aws_security_group.external-secg.id}"]
}
