variable "subnet_name" {
  type = string
  description = "subnet ka name"
}

variable "rg_name" {
  type = string
  description = "rg ka name"
}

variable "vnet_name" {
  type = string
  description = "vnet ka name"
}

variable "address_prefixes" {
  type = list(string)
  description = "ip address"
}