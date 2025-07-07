module "rg" {
  source = "../module/resource_group"

  rg_name = "bhawani-rg"
  location = "central india"
}

module "virtual_network" {
  source = "../module/virtual_network"
  depends_on = [ module.rg ]

  vnet_name = "chiku-vnet"
  location = "central india"
  rg_name = "bhawani-rg"
}

module "frontend-subnet" {
  source = "../module/subnet"
  depends_on = [ module.rg, module.virtual_network ]

  subnet_name = "frontend"
  rg_name = "bhawani-rg"
  vnet_name = "chiku-vnet"
  address_prefixes = ["10.0.1.0/24"]
}

module "public_ip" {
  source = "../module/public_ip"
  depends_on = [ module.rg ]

  pip_name = "frontend-ip"
  rg_name = "bhawani-rg"
  location = "central india"
}

module "sql" {
  source = "../module/sql"
  depends_on = [ module.rg ]

  sql_server_name = "chiku-sql-server"
  rg_name = "bhawani-rg"
  location = "central india"
  db_name = "tikku-db"
}

module "frontendvm" {
  source = "../module/virtula_machin"
  depends_on = [ module.rg,module.frontend-subnet,module.public_ip,module.virtual_network ]

  nic_name = "lillunic"
  location = "central india"
  rg_name = "bhawani-rg"
  vm_name = "frontendvm"
  pip_name = "frontend-ip"
  subnet_name = "frontend"
  vnet_name = "chiku-vnet"
}

