variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

# variable "db_password_name" {
#   type = string
# }

variable "db_password_value" {
  type      = string
  sensitive = true
}

variable "environment" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "postgres_admin_name" {
  type = string
}

variable "postgres_admin_password" {
  type      = string
  sensitive = true
}