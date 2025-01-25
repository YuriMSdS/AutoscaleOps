resource "aws_instance" "auto_scale_instance" {
  ami           = "ami-0eb070c40e6a142a3"
  instance_type = var.instance_type
  key_name = "scaleops"
}