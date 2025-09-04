# output "created_new_dns_zone_id" {
#   value       = azurerm_private_dns_zone.private_dns_zone.id
#   description = "value of the dns zone id when no existing dns zone is null"

# }
output "pv_endpoint_resource_id" {
  value       = azurerm_private_endpoint.private_endpoint.id
  description = "value of the private endpoint id"

}
