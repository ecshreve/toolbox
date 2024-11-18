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