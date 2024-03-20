variable "project_id" {
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "region" {
  description = "The region in which resources will be provisioned."
  type        = string
}

variable "zone" {
  description = "The zone in which resources will be provisioned."
  type        = string
}

variable "instance_count" {
  description = "The number of instances to create."
  type        = number
}

variable "instance_type" {
  description = "The type of the instance to create."
  type        = string
}

variable "db_name" {
  description = "The name of the MySQL database."
  type        = string
}

variable "db_user" {
  description = "The username for the MySQL database."
  type        = string
}

variable "db_password" {
  description = "The password for the MySQL database."
  type        = string
}

variable "wordpress_url" {
  description = "The URL for the WordPress site."
  type        = string
}