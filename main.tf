terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
    }
  }
}

provider "equinix" {
  client_id = ""
  client_secret = ""
  }
resource "equinix_network_device" "cisco8kv-ha" {
name            = "fabm-c8000v-pri"
metro_code      = "DA"
type_code       = "C8000V"
self_managed    = true
byol            = true
package_code    = "network-essentials"
notifications   = ["fabmarquez@equinix.com"]
hostname        = "fabm-c8000v-p"
account_number  = "665607"
version         = "17.09.04a"
core_count      = 2
term_length     = 1
additional_bandwidth = 0
project_id      = "89ef02a9-1773-41ec-a1c9-aa30e34493a6"
  ssh_key {
   username = "fabmarquez"
}
acl_template_id = "af5a9c9b-c58a-4594-9e68-ae6c2151b929"
 
secondary_device {
   name            =  "fabm-c8000v-sec"
   metro_code      = "SV"
   hostname        = "fabm-c8000v-s"
   notifications   = ["fabmarquez@equinix.com"]
   account_number  = "665607"
   acl_template_id = "af5a9c9b-c58a-4594-9e68-ae6c2151b929"
   }  
}
resource "equinix_network_device_link" "DLG" {
  name   = "fabm-DLG-link"
  project_id  = "89ef02a9-1773-41ec-a1c9-aa30e34493a6"
  device {
    id           = equinix_network_device.cisco8kv-ha.uuid
    interface_id = 6
  }
  device {
    id           = equinix_network_device.cisco8kv-ha.secondary_device[0].uuid
    interface_id = 6
  }
  metro_link {
    account_number  = "665607"
    metro_code  = "DA"
    throughput      = "10"
    throughput_unit = "Mbps"
  }
    metro_link {
    account_number  = "665607"
    metro_code  = "SV"
    throughput      = "10"
    throughput_unit = "Mbps"
  }
}