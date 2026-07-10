provider "aws" {
  region = "eu-west-1" 
}

# 1. Create the VPC (Network Isolation)
resource "aws_vpc" "fintech_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "dexter-fintech-vpc"
  }
}

# 2. Public Subnet for the Load Balancer
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.fintech_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "dexter-public-subnet"
  }
}

# 3. Private Subnet for Application Containers
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.fintech_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "dexter-private-subnet"
  }
}

# 4. AWS ECS Cluster to Run Containers
resource "aws_ecs_cluster" "fintech_cluster" {
  name = "dexter-fintech-cluster"
}

# 5. Database Instance (PostgreSQL) in Isolated Setup
resource "aws_db_instance" "postgres_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t4g.micro" 
  db_name              = "fintech_wallet"
  username             = "db_admin"
  password             = "SecureProdPlaceholder2026!" 
  skip_final_snapshot  = true
  multi_az             = true 
}
