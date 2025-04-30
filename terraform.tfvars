# Name of the n/w(VPC)
vpc_name = "i27-ecommerce-vpc"

# List of subnets to be created 
subnets = [
    {
        name = "i27-ecommerce-central-subnet"
        ip_cidr_range = "10.1.0.0/16"
        subnet_region = "us-central1"
    },
    {
        name = "i27-ecommerce-east4-subnet"
        ip_cidr_range = "10.2.0.0/16"
        subnet_region = "us-east4"
    }
]

# Name of the firewall
firewall_name = "i27-allow-ssh-http-jenkins-ports"

# Source Ranges
source_ranges = [ "0.0.0.0/0" ]

instances  = {
    "ansible" = {
        instance_type = "e2-medium"
        zone = "us-central1-a"
        subnet = "i27-ecommerce-central-subnet"
        disk_size = 10
    },
    "jenkins-master" = {
        instance_type = "e2-medium"
        zone = "us-east4-b"
        subnet = "i27-ecommerce-east4-subnet"
        disk_size = 20  
    },
    "jenkins-slave" = {
        instance_type = "e2-medium"
        zone = "us-east4-b"
        subnet = "i27-ecommerce-east4-subnet"
        disk_size = 20
    },
}


vm_user = "rama"