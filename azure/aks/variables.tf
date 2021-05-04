variable "name" {
  default = "mostela"
}

variable "vm_size" {
  default = "Standard_D2_v2"
}

variable "count_nodes" {
  default = 1
  type = number
}
variable "environment" {
  default = "Production"
}