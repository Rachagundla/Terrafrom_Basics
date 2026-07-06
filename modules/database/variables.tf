variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "postgresql_administrator_login" {
  type = string
}

variable "postgresql_administrator_password" {
  type = string
  sensitive = true
}

variable environment {
  type        = string
}
