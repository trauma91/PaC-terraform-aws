variable "docker_image_tag" {
  description = "The name of the cluster to be created"
  default     = "latest"
}

variable "cluster_name" {
  description = "The name of the cluster to be created"
  default     = "cpalese_empatica"
}

variable "task_be_name" {
  description = "The name of the task thay will run the be application"
  default = "be"
}

variable "container_be_name" {
  description = "The name of the be container"
  default     = "be"
}

variable "service_be_name" {
  description = "The name of the service thay will run be tasks"
  default = "service_be"
}

variable "lb_be_name" {
  description = "The name of the load balancer above the be service"
  default = "lb-be"
}

variable "db_name" {
  description = "The name of the RDS db"
  default = "empatica"
}

variable "db_username" {
  description = "The db user"
  default = "user"
}

variable "db_password" {
  description = "The password for db user"
  default = "password"
}