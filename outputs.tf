output "hadoop_nodes_ips" {
  value = aws_instance.hadoop_nodes[*].public_ip
}

output "ansible_node_ip" {
  value = aws_instance.ansible_node[0].public_ip
}
