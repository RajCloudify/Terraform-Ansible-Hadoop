variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "hadoop_cluster_size" {
  description = "Number of Hadoop cluster nodes (excluding Ansible node)"
  type        = number
}

variable "ansible_node_count" {
  description = "Number of Ansible control nodes"
  type        = number
}
