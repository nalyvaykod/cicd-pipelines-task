variable "location" {
  description = "Azure Region"
  type        = string
  default     = "UK South"
}
# Secrets(test pipeline)

variable "prefix" {
  description = "Prefix for unique resource names"
  type        = string
  default     = "bestrong"
}

# Secrets    
variable "sql_admin_username" {
  description = "Admin SQL Server username"
  type        = string
  sensitive   = true
}
# Secrets(test pipeline)

variable "sql_admin_password" {
  description = "Admin SQL Server password"
  type        = string
  sensitive   = true
}
