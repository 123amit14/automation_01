# ec2-instance-module/outputs.tf

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.instance.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.instance.public_ip
}
