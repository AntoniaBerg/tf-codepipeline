data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.image-name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"]
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