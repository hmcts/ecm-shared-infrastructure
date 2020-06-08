variable "product" {
  type    = string
  default = "ethos"
}

variable "location" {
  type    = string
  default = "UK South"
}

variable "env" {
  type = string
}

variable "subscription" {
  type = string
}

variable "ilbIp"{}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. This is usually sourced from environemnt variables and not normally required to be specified."
}

variable "jenkins_AAD_objectId" {
  type                        = string
  description                 = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

variable "capacity" {
  default = "1"
}

variable "deployment_namespace" {
  default = ""
}

variable "common_tags" {
  type = map(string)
}

variable "component" {
  type = string
}

variable "location_api" {
  type    = string
  default = "UK South"
}

variable "managed_identity_object_id" {
  default = ""
}

variable "appinsights_location" {
  type        = string
  default     = "West Europe"
  description = "Location for Application Insights"
}

variable "application_type" {
  type = string
  default = "Web"
  description = "Type of Application Insights (Web/Other)"
}

variable "queue_max_delivery_count" {
  type        = string
  default     = "10"
  description = "Queue message max delivery counter. Extracted to variable so it can be assigned to application environment."
}

variable "team_name" {
  type        = string
  description = "Team name"
  default     = "ECM Project"
}

variable "team_contact" {
  type        = string
  description = "Team contact"
  default     = "#ethos-repl-service"
}

variable "destroy_me" {
  type        = string
  description = "Here be dragons! In the future if this is set to Yes then automation will delete this resource on a schedule. Please set to No unless you know what you are doing"
  default     = "No"
}