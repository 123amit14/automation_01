# vpc-module/variables.tf

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "Test_VPC"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"] # Change to your preferred defaults
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_1_name" {
  description = "Name tag for the first public subnet"
  type        = string
  default     = "Public_Subnet_1"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_subnet_2_name" {
  description = "Name tag for the second public subnet"
  type        = string
  default     = "Public_Subnet_2"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_name" {
  description = "Name tag for the private subnet"
  type        = string
  default     = "Private_Subnet"
}

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
  default     = "Internet_Gateway"
}

variable "public_route_table_name" {
  description = "Name tag for the Public Route Table"
  type        = string
  default     = "Public_Route_Table"
}
