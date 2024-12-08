terraform { 
  required_providers {
    multipass = {
      source  = "larstobi/multipass"
      version = "~> 1.4.2"
    }
  }
}

resource "multipass_instance" "devbox" {
    count = 1
    name  = "devbox"
    image = "noble"
    cpus  = 4
    memory = "8gb"
    disk = "20gb"
    cloudinit_file = "userdata.cfg"
}

data "multipass_instance" "devbox" {
    name = "devbox"
    depends_on = [multipass_instance.devbox]
}

resource "local_file" "multipass_inventory" {
  content = templatefile("${path.module}/hosts_multipass.tpl", {
    ip_address = data.multipass_instance.devbox.ipv4
  })
  filename = "${path.module}/../ansible/hosts_multipass.yml"
}