variable "instance_type" {
  default = "t2.micro"
}

variable "private_key_path" {
  description = "Caminho para chave .pem"
  type = string
  default = "/Users/yurimiguel/Desktop/AutoscaleOps/scaleops.pem"
}