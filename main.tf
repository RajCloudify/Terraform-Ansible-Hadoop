resource "aws_instance" "hadoop_nodes" {
  count         = var.hadoop_cluster_size
  ami          = "ami-00bb6a80f01f03502" # Update this with latest Ubuntu AMI
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = "Hadoop-Node-${count.index}"
  }
}
resource "aws_instance" "ansible_node" {
  count         = var.ansible_node_count
  ami          = "ami-00bb6a80f01f03502"
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = "Ansible-Node"
  }
}
