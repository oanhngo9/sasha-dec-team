variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "dec-team-vpc"  # replace with your VPC name
}

variable "region" {
  description = "The region of the project"
  type        = string
  default     = "us-central1"  # replace with your region
}

variable "asg_name" {
  type        = string
  default     = "decasg"
  description = "desired name for the autoscaling"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
  description = "zone where to deploy resource"
}

variable "minimum_instances" {
  type        = number
  default     = 1
  description = "minimum desired instances running"
}

variable "maximum_instances" {
  type        = number
  default     = 5
  description = "maximum desired instances"
}

variable "template_name" {
  type        = string
  default     = "sasha-template"
  description = "desired name for the compute instance template"
}

variable "machine_type" {
  type        = string
  default     = "e2-standard-4"
  description = "add your machine type"
}

variable "targetpool_name" {
  type        = string
  default     = "team-gcp-project"
  description = "description"
}

variable "igm_name" {
  type        = string
  default     = "team-gcp-project"
  description = "description"
}

variable "data_base_version" {
  type        = string
  default     = "MYSQL_5_7" #MYSQL_5_6, MYSQL_5_7, MYSQL_8_0, POSTGRES_9_6,POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13, SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, SQLSERVER_2017_WEB
  description = "specifies the database version"
}

variable "dbinstance_name" {
  type        = string
  default     = "sasha-instance"
  description = "Name of the database instance"
}

variable "db_version" {
  type        = string
  default     = "MYSQL_5_7"
  description = "Version of the database"
}

variable "db_region" {
  type        = string
  default     = "us-central1"
  description = "Region where the resources will be created"
}

variable "db_user" {
  type        = string
  default     = "sasha-username"
  description = "Username for the database"
}

variable "db_host" {
  type        = string
  default     = "sasha-host"
  description = "Host for the database"
}

variable "db_password" {
  type        = string
  default     = "12345678"
  description = "Password for the database"
}

variable "db_name" {
  type        = string
  default     = "sasha-db"
  description = "Name of the database"
}

variable "instance_count" {
  description = "The number of instances to create."
  default = 1
  type        = number
}

variable "secret_id" {
  description = "The id of the secret"
  default = "fhoclkvzqv"
  type        = string
}

