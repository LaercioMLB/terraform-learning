provider "aws" {
  region = "us-east-1" # Substitua pela região desejada
}
# Instância EC2
resource "aws_instance" "ec2_instance" {
  ami           = "ami-0866a3c8686eaeeba" # Substitua pelo ID da AMI desejada  ami-005fc0f236362e99f - PADR1
  instance_type = "t2.micro"              # Tipo de instância
  key_name      = var.key_name            # Nome do Key Pair já existente
  subnet_id     = var.subnet_id           # Subnet existente
  private_ip    = var.private_ip          # IP privado da instancia

  vpc_security_group_ids = [
    var.security_group_id                 # Security Group já existente
  ]

  tags = {
    Name = "MyTerraformEC2"              # Nome da instância
  }
}

# Volumes EBS para cada ponto de montagem

resource "aws_ebs_volume" "shm" {
  size              = 1
  type              = "gp3"
  availability_zone = aws_instance.ec2_instance.availability_zone
  tags = {
    Name = "/dev/shm"
  }
}

resource "aws_ebs_volume" "tmp" {
  size              = 1
  type              = "gp3"
  availability_zone = aws_instance.ec2_instance.availability_zone
  tags = {
    Name = "/tmp"
  }
}

resource "aws_ebs_volume" "home" {
  size              = 1
  type              = "gp3"
  availability_zone = aws_instance.ec2_instance.availability_zone
  tags = {
    Name = "/home"
  }
}

resource "aws_ebs_volume" "var" {
  size              = 3
  type              = "gp3"
  availability_zone = aws_instance.ec2_instance.availability_zone
  tags = {
    Name = "/var"
  }
}

resource "aws_ebs_volume" "var_log" {
  size              = 2
  type              = "gp3"
  availability_zone = aws_instance.ec2_instance.availability_zone
  tags = {
    Name = "/var/log"
  }
}

resource "aws_ebs_volume" "var_tmp" {
  size              = 1
  type              = "gp3"
  availability_zone = aws_instance.ec2_instance.availability_zone
  tags = {
    Name = "/var/tmp"
  }
}

resource "aws_ebs_volume" "opt" {
  size              = 12
  type              = "gp3"
  availability_zone = aws_instance.ec2_instance.availability_zone
  tags = {
    Name = "/opt"
  }
}

resource "aws_ebs_volume" "swap" {
  size              = 4
  type              = "gp3"
  availability_zone = aws_instance.ec2_instance.availability_zone
  tags = {
    Name = "swap"
  }
}

# Anexar volumes à instância

resource "aws_volume_attachment" "shm" {
  device_name = "/dev/xvdg"
  volume_id   = aws_ebs_volume.shm.id
  instance_id = aws_instance.ec2_instance.id
}

resource "aws_volume_attachment" "tmp" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.tmp.id
  instance_id = aws_instance.ec2_instance.id
}

resource "aws_volume_attachment" "home" {
  device_name = "/dev/xvdi"
  volume_id   = aws_ebs_volume.home.id
  instance_id = aws_instance.ec2_instance.id
}

resource "aws_volume_attachment" "var" {
  device_name = "/dev/xvdj"
  volume_id   = aws_ebs_volume.var.id
  instance_id = aws_instance.ec2_instance.id
}

resource "aws_volume_attachment" "var_log" {
  device_name = "/dev/xvdk"
  volume_id   = aws_ebs_volume.var_log.id
  instance_id = aws_instance.ec2_instance.id
}

resource "aws_volume_attachment" "var_tmp" {
  device_name = "/dev/xvdl"
  volume_id   = aws_ebs_volume.var_tmp.id
  instance_id = aws_instance.ec2_instance.id
}

resource "aws_volume_attachment" "opt" {
  device_name = "/dev/xvdm"
  volume_id   = aws_ebs_volume.opt.id
  instance_id = aws_instance.ec2_instance.id
}

resource "aws_volume_attachment" "swap" {
  device_name = "/dev/xvdn"
  volume_id   = aws_ebs_volume.swap.id
  instance_id = aws_instance.ec2_instance.id
}


# Outputs para ajudar no gerenciamento
output "instance_id" {
  description = "ID da Instância EC2 criada"
  value       = aws_instance.ec2_instance.id
}

output "volume_ids" {
  description = "IDs de todos os Volumes EBS criados"
  value = [
    aws_ebs_volume.shm.id,
    aws_ebs_volume.tmp.id,
    aws_ebs_volume.home.id,
    aws_ebs_volume.var.id,
    aws_ebs_volume.var_log.id,
    aws_ebs_volume.var_tmp.id,
    aws_ebs_volume.opt.id,
    aws_ebs_volume.swap.id,
  ]
}

output "private_ip" {
  description = "Endereço IP público da Instância"
  value       = aws_instance.ec2_instance.private_ip
}
