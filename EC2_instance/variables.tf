variable "vault_addr" {
  default="http://127.0.0.1:8200"
}
variable "vault_token" {
  default = "hvs.7lfH16EZNn7MLDqRPsYjP6nw"
}
variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-005f9685cb30f234b"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}

variable "region" {
  default = "us-west-1"
}