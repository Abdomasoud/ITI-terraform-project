variable "ami" {
  description = "AMI ID for the instance"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string

}

variable "db_username" {
  description = "Database username"
  type        = string
  
}

variable "db_password" {
  description = "Database password"
  type        = string

}