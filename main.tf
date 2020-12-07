data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-0bd39c806c2335b9"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "web" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.amazonlinux.id

  tags = {
    env = "test"
    description = "EC2 - Example"
    author = "Antonia Berg"
  }
}