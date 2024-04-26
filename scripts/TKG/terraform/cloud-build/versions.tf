terraform {
  required_providers {
    tanzu-mission-control = {
      source = "vmware/tanzu-mission-control"
      version = ">=1.4.1"
    }
    nsxt = {
      source = "vmware/nsxt"
      version = "3.3.1"
    }
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.4.1"
    }
  }
  
  required_version = ">=1.0.0"

  cloud {
    organization = "dellcc"

    workspaces {
      name = "tanzu-poc-dell-dev"
    }
  }
}
