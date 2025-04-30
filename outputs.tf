# Have private and public ip of all the instances created 
output "instance_ips" {
  value = {
    for instance in google_compute_instance.tf-vm-instance :
        instance.name => {
            public_ip = instance.network_interface.0.access_config[0].nat_ip
            private_ip = instance.network_interface[0].network_ip
        }
  }
}

# SSH to VM 
# ssh -i private_key username@public_ip_address

output "ansible_ssh_command" {
  value = "To connect to ansible vm, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["ansible"].network_interface.0.access_config[0].nat_ip}"
}

output "jenkins_master_ssh_command" {
  value = "To connect to jenkins-master vm, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["jenkins-master"].network_interface.0.access_config[0].nat_ip}"
}

# # public ip od ansible 
# output "ansible_instance_public_ip" {
#   value = google_compute_instance.tf-vm-instance["ansible"].network_interface.0.access_config[0].nat_ip
# }
# # Public ip of jenkins-master 
# output "jenkins_master_instance_public_ip" {
#   value = google_compute_instance.tf-vm-instance["jenkins-master"].network_interface.0.access_config[0].nat_ip
# }

# public ip of jenkins-slave