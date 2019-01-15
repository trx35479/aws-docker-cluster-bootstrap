# output the subnet's

output "main-public-1" {
  value = "${aws_subnet.main-public-1.id}"
}

output "main-public-2" {
  value = "${aws_subnet.main-public-2.id}"
}

output "main-public-3" {
  value = "${aws_subnet.main-public-3.id}"
}

output "main-private-1" {
  value = "${aws_subnet.main-private-1.id}"
}

output "main-private-2" {
  value = "${aws_subnet.main-private-2.id}"
}

output "main-private-3" {
  value = "${aws_subnet.main-private-3.id}"
}

output "internal-secg" {
  value = "${aws_security_group.internal-secg.id}"
}

output "external-secg" {
  value = "${aws_security_group.external-secg.id}"
}
