resource "azurerm_mssql_server" "todo-sql" {
  name                         = var.sql_server_name
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.username.value
  administrator_login_password = data.azurerm_key_vault_secret.password.value
  minimum_tls_version          = "1.2"
}


resource "azurerm_mssql_database" "todo-db" {
  depends_on = [ azurerm_mssql_server.todo-sql ]
  name         = var.db_name
  server_id    = azurerm_mssql_server.todo-sql.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

}

data "azurerm_key_vault" "kv" {
  name                = "joytijori"
  resource_group_name = "joy-rg"
}

data "azurerm_key_vault_secret" "username" {
  name         = "sqlusername"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "password" {
  name         = "sqlpassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}
