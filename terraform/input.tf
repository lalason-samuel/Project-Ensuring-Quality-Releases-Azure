# # Azure GUIDS
variable "subscription_id" { default = "fe543d6c-d65a-4f94-99e0-886fb95f57dd" }
variable "client_id" { default = "3308c0af-98ed-4fc6-9636-0dbd131c6646" }
variable "client_secret" { default = "hDm8Q~9icHuYbVj6E1ZQ8TE.jI.rkvx8J6_jVcsw" }
variable "tenant_id" { default = "f958e84a-92b8-439f-a62d-4f45996b6d07" }

# Resource Group/Location
variable "location" {}
variable "resource_group" {}
variable "application_type" {}

variable "password" {
  description = "entrer password please"
  sensitive   = true
  default     = "S@miMvola1234"
}


# # Network
# variable virtual_network_name {}
# variable address_prefix_test {}
# variable address_space {}

