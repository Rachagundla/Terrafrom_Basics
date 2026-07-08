# variables are declaring with default value
variable "rg_Location" {
  type        = string
  default     = "Central India"
  description = "Resource group location"
}

variable "rg_Name" {
  type        = string
  default     = "rg-dev"
  description = "Resource group Name"
}


variable "storage_account_name" {
  type        = string
  default     = "dev-storage-account"
  description = "description"
}

variable "environment" {
  type        = list(string)
  default     = ["dev", "test", "prod"]
  description = "List of deployment environments"
}

variable "storage_container_name" {
  type        = string
  default     = "storage-account-container-tfstate"
  description = ""
}

variable "postgresql_administrator_login" {
  type = string
}

variable "postgresql_administrator_password" {
  type = string
}

# variable "db_password_name" {
#   type = string
# }

# variable "db_password_value" {
#   type = string
# }
