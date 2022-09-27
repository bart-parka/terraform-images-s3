### General Variables ###
variable "profile" {
  description = "Profile to deploy to"
  type        = string
}

variable "region" {
  description = "Region to deploy to"
  type        = string
  default     = "eu-west-2"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default = {
    Owner = "Bart Parka"
  }
}