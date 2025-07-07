data "azurerm_public_ip" "todo-pip" {
  name                = var.pip_name
  resource_group_name = var.rg_name
}

data "azurerm_subnet" "todo-subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
}


resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    public_ip_address_id          = data.azurerm_public_ip.todo-pip.id
    subnet_id                     = data.azurerm_subnet.todo-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = data.azurerm_key_vault_secret.username.value
  admin_password      = data.azurerm_key_vault_secret.password.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF
)
}


data "azurerm_key_vault" "kv" {
  name                = "joytijori"
  resource_group_name = "joy-rg"
}

data "azurerm_key_vault_secret" "username" {
  name         = "vmusername"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "password" {
  name         = "vmpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}


