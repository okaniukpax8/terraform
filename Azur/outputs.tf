output "public_ip_address" {
  value = "http://${azurerm_public_ip.main.ip_address}"
}