resource "aws_instance" "test_server" {
  ami           = var.ami
  instance_type = var.instance_type
  
  tags = {
    Name        = "terra-example"
  }
}