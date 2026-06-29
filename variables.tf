# variables are declaring with default value
variable "rg_Location" {
  type        = string
  default     = "East US"
  description = "Resource group location"
}

variable "rg_Name" {
  type        = string
  default     = "rg-dev"
  description = "Resource group Name"
}


variable "storage-account-name" {
  type        = string
  default     = "devStorageAccount"
  description = "description"
}

variable "environment" {
  type        = list(string)
  default     = ["dev", "test", "prod"]
  description = "List of deployment environments"
}


