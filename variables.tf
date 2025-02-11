variable "key_name" {
  description = "SSH key pair name"
  type        = string
  sensitive = true
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

