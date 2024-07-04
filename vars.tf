variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
    default = "us-south"

    validation  {
      error_message = "Must use an IBM Cloud region. Use `ibmcloud regions` with the IBM Cloud CLI to see valid regions."
      condition     = can(
        contains([
          "au-syd",
          "jp-tok",
          "eu-de",
          "eu-gb",
          "us-south",
          "us-east"
        ], var.ibm_region)
      )
    }
}
variable resource_group {
    description = "Name of resource group where all infrastructure will be provisioned"
    type        = string
    default     = "vpc-demo-rg"

    validation  {
      error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
      condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.resource_group))
    }
}
variable "ssh_keyname" {
    default = "ssh-key-demo-dallas"
    description = "ssh key name of region"
}
variable "name_vpc" {
    default = "vpc-demo-dallas"
    description = "vpc name region"
}
variable vms {
    description = "List of vm for control plane"
    type = list(object({
        name = string
        profile = string
        subnet = string
        image = string
        zone = number
        count = number
    }))
    default = [
        {
            name = "vsi-rhel-dal1"
            profile = "bx2d-4x16"
            subnet = "sn-20240703-01"
            image = "r006-066a97dc-ebb3-4e44-8f1e-9ccae5b47e2a"
            zone = 1
            count = 2
        },
        {
            name = "vsi-centos-dal2"
            profile = "bx2d-4x16"
            subnet = "sn-20240703-02"
            image = "r006-066a97dc-ebb3-4e44-8f1e-9ccae5b47e2a"
            zone = 2
            count = 1
        },
    ]
}