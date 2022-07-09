variable "cluster-name" {
  default = "mostela-test"
  type = string
}

variable "task-name" {
  type = string
  default = "nginx"
}

variable "task-image" {
  type = string
  default = "nginx"
}