variable "owner" {
  description = "base name : <type of deployment>-<company name>"
}

variable "workload" {

}
variable "environment_type" {
  description = "enviroment type"
  type        = string
}

variable "default_tag" {
  description = "default tag use across the rosources created"
  type        = map(any)
}

variable "region" {
  description = "azure region"
}

variable "location_short" {
  default = "sea"
}

variable "number_instance" {
  description = "number - 001"
}
