# Output the master IP address

output "master_ip" {
  value = "${aws_instance.master-instance.*.private_ip}"
}
