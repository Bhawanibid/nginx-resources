resource "azurerm_public_ip" "todo-pip" {
  name                = var.pip_name
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
}

variable "pip_name" {
  type = string
  description = "pip ka name"
}

variable "rg_name" {
  type = string
  description = "rg ka name"
}

variable "location" {
  type = string
  description = "location"
}