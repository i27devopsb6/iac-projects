# Generate SSH Key pair, combination of public and private key
# RSA key of size 2048 bits
# ssh-key -t rsa
resource "tls_private_key" "i27-ecommerce-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key to local file 
resource "local_file" "i27-ecommerce-key-private" {
  content = tls_private_key.i27-ecommerce-key.private_key_pem
  filename =  "${path.module}/id_rsa"  
}

# Save the public key to local file 
resource "local_file" "i27-ecommerce-key-public" {
  content = tls_private_key.i27-ecommerce-key.public_key_openssh
  filename =  "${path.module}/id_rsa.pub"  
}

# Creating Multiple Google Compute instances using single resourse block.  
resource "google_compute_instance" "tf-vm-instance" {
  // code to create vms 
  for_each = var.instances
  name = each.key
  machine_type = each.value.instance_type
  zone = each.value.zone 
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20250415"
      size  = each.value.disk_size
      type  = "pd-standard"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.self_link
    subnetwork = each.value.subnet
    access_config {
      // Ephemeral ips
    }
  }
  # Below metadata will place the public key in the vm 
  metadata = {
    ssh-keys = "${var.vm_user}:${tls_private_key.i27-ecommerce-key.public_key_openssh}"
  }

  connection {
    host = self.network_interface[0].access_config[0].nat_ip
    type = "ssh" # winrm
    user = var.vm_user
    private_key = tls_private_key.i27-ecommerce-key.private_key_pem
  }
  # provisioner
  provisioner "file" {
    source =  each.key == "ansible" ? "ansible.sh" : "empty.sh"  
    destination = each.key == "ansible" ? "/home/${var.vm_user}/ansible.sh" : "/home/${var.vm_user}/empty.sh"
  }

  # Providioner block to eecute the script on the remote server 
  provisioner "remote-exec" {
    inline = [ 
      each.key == "ansible" ? "chmod +x /home/${var.vm_user}/ansible.sh && /home/${var.vm_user}/ansible.sh" : "echo 'Not an ansible vm'"
     ]
  }

 # File Provisioner to copy private key all on the vms
 provisioner "file" {
   source = "${path.module}/id_rsa"
   destination = "/home/${var.vm_user}/ssh-key"
 }




 
}