terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = ">=1.19.0"
    }
  }
}
provider ibm {
    alias  = "primary"
    region = var.ibm_region
    max_retries = 20
}

data ibm_resource_group group {
    provider = ibm.primary
    name = var.resource_group
}

data "ibm_is_ssh_key" "sshkey" {
  provider = ibm.primary
  name = var.ssh_keyname
}

data "ibm_is_vpc" "vpc" {
  provider = ibm.primary
  name = var.name_vpc
}

data "ibm_is_subnet" "subnet_1" {
  provider = ibm.primary
  name = var.name_subnet_1
}

data "ibm_is_subnet" "subnet_2" {
  provider = ibm.primary
  name = var.name_subnet_2
}

resource "ibm_is_instance" "vsi" {
    for_each = { for vm in var.vms : vm.name => vm }
    provider = ibm.primary
    name    = each.value.name
    profile = each.value.profile
    image = each.value.image

    primary_network_interface {
      subnet = data.ibm_is_subnet[each.subnet].id
    }

    vpc       = data.ibm_is_vpc.vpc.id
    zone      = "${var.ibm_region}-${each.value.zone}"
    keys      = [data.ibm_is_ssh_key.sshkey.id]
    resource_group = data.ibm_resource_group.group.id
}