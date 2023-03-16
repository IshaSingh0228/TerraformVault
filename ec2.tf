resource "aws_instance" "ec2_server" {
    ami = "ami-005f9685cb30f234b"
    instance_type = "t2.micro"

    tags = {
        Name = "vault"
    }
  
}