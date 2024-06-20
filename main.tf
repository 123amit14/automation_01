# main.tf

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./vpc-module"

  vpc_cidr                = "10.0.0.0/16"
  vpc_name                = "My_Test_VPC"
  public_subnet_1_cidr    = "10.0.1.0/24"
  public_subnet_1_name    = "My_Public_Subnet_1"
  public_subnet_2_cidr    = "10.0.2.0/24"
  public_subnet_2_name    = "My_Public_Subnet_2"
  private_subnet_cidr     = "10.0.3.0/24"
  private_subnet_name     = "My_Private_Subnet"
  igw_name                = "My_Internet_Gateway"
  public_route_table_name = "My_Public_Route_Table"
  availability_zones      = ["ap-south-1a", "ap-south-1b"] # Specify the AZs
}

module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier             = "my-wordpress-db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = "admin"
  password               = "Testdb@321"
  publicly_accessible    = false
  vpc_security_group_ids = [module.private_security_group.sg_id]
  subnet_ids             = [module.vpc.private_subnet_id]
  db_name                = "wordpressdb"

  major_engine_version = "5.7"      # Specify the MySQL engine version here
  family               = "mysql5.7" # Specify the DB parameter group family here
}


module "public_security_group" {
  source = "./security-group-module"

  sg_name        = "Public_Security_Group"
  sg_description = "Security group for public instances"
  vpc_id         = module.vpc.vpc_id
  ingress_rules = [
    {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name = "Public_Security_Group"
  }
}

module "private_security_group" {
  source = "./security-group-module"

  sg_name        = "Private_Security_Group"
  sg_description = "Security group for private instances"
  vpc_id         = module.vpc.vpc_id
  ingress_rules = [
    {
      description = "Allow SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    {
      description = "Allow MySQL"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = {
    Name = "Private_Security_Group"
  }
}

module "public_ec2_instance_1" {
  source = "./ec2-instance-module"

  ami                         = "ami-0f58b397bc5c1f2e8" # Replace with a valid AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnet_1_id
  security_group_ids          = [module.public_security_group.sg_id]
  associate_public_ip_address = true
  tags = {
    Name = "Public_EC2_Instance_1"
  }
}

module "public_ec2_instance_2" {
  source = "./ec2-instance-module"

  ami                         = "ami-0f58b397bc5c1f2e8" # Replace with a valid AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnet_2_id
  security_group_ids          = [module.public_security_group.sg_id]
  associate_public_ip_address = true
  tags = {
    Name = "Public_EC2_Instance_2"
  }
}

module "private_ec2_instance" {
  source = "./ec2-instance-module"

  ami                         = "ami-0f58b397bc5c1f2e8" # Replace with a valid AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.private_subnet_id
  security_group_ids          = [module.private_security_group.sg_id]
  associate_public_ip_address = false
  tags = {
    Name = "Private_EC2_Instance"
  }
}

output "vpc_id_" {
  value = module.vpc.vpc_id
}

output "public_subnet_1_id_" {
  value = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id_" {
  value = module.vpc.public_subnet_2_id
}

output "private_subnet_id_" {
  value = module.vpc.private_subnet_id
}

output "igw_id_" {
  value = module.vpc.igw_id
}

output "public_route_table_id_" {
  value = module.vpc.public_route_table_id
}

output "public_sg_id_" {
  value = module.public_security_group.sg_id
}

output "private_sg_id_" {
  value = module.private_security_group.sg_id
}

output "public_ec2_instance_1_id_" {
  value = module.public_ec2_instance_1.instance_id
}

output "public_ec2_instance_2_id_" {
  value = module.public_ec2_instance_2.instance_id
}

output "private_ec2_instance_id_" {
  value = module.private_ec2_instance.instance_id
}

output "public_ec2_instance_1_public_ip_" {
  value = module.public_ec2_instance_1.public_ip
}

output "public_ec2_instance_2_public_ip_" {
  value = module.public_ec2_instance_2.public_ip
}
