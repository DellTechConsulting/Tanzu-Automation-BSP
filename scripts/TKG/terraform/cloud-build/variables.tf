variable "endpoint" {
  type = string
  default = "dell.tmc.cloud.vmware.com"
}

# The TMC api token
variable "vmw_cloud_api_token" {
  type = string
  sensitive = true
}

variable "vmw_cloud_endpoint" {
  default = "console.cloud.vmware.com"
}

variable "management_cluster_name" {
  type = string
}

variable "provisioner_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_group" {
  type = string
}

variable "storage_capacity" {
  type = string
}

variable "storage_class" {
  type = string
}

variable "ntp" {
  type = string
}

variable "tkgs_version" {
  type = string
}

variable "environment" {
  type = string  
}

# Additional variables for VCF project
/* variable "nsxt_host" {
  description = "The NSX-T Manager host. Must resolve to a reachable IP address, e.g. `nsxmgr.example.tld`"
  type        = string
}

variable "nsxt_username" {
  description = "The NSX-T username, probably `admin`"
  type        = string
}

variable "nsxt_password" {
  description = "The NSX-T password"
  type        = string
  sensitive   = true
} */

variable "vcenter_host" {
  description = "The vCenter host. Must resolve to a reachable IP address, e.g. `vcenter.example.tld`"
  type        = string
}

variable "vcenter_username" {
  description = "The vCenter username, probably `administrator@vsphere.local`"
  type        = string
}

variable "vcenter_password" {
  description = "The vCenter password"
  type        = string
  sensitive   = true
}

variable "allow_unverified_ssl" {
  description = "Allow connection to NSX-T manager with self-signed certificates. Set to `true` for POC or development environments"
  default     = false
  type        = bool
}

/* variable "nsxt_edge_cluster_name" {
  default     = "vsdellpqrfedgewldm1"
  description = "The name of the edge cluster where the T1 gateways will be provisioned"
  type        = string
}

variable "nsxt_active_t0_gateway_name" {
  default     = "dell-01-vDLRT0-02-u007"
  description = "The name of the T0 gateway where the T1s will be connected to"
  type        = string
}

variable "east_west_transport_zone_name" {
  default     = "overlay-tz-vsdellpqrfwnsx.dellcc.org"
  description = "The name of the Transport Zone that carries internal traffic between the NSX-T components. Also known as the `overlay` transport zone"
  type        = string
}

variable "avi_cluster_egress_snat_ip" {
  description = "The IP address of the AVI cluster T1 SNAT"
  type        = string
}

variable "tkgs_workload_domain_group_id" {
  default     = "dg-domain:5c67c598-0522-4009-83fc-3018141dc089"
  description = "The domain group ID in NSX-T"
  type        = string
}

variable "tkgs_workload_domain_group_domain" {
  default     = "domain:5c67c598-0522-4009-83fc-3018141dc089"
  description = "The domain group domain name in NSX-T"
  type        = string
}

variable "avi_vip_segment_cidr" {
  description = "CIDR of the Avi VIP network"
  type        = string
}

variable "tanzu-namespace-network" {
  description = "CIDR of the Tanzu vSphere namespace network"
  type        = string
} */

variable "environment_type" {
  default     = "d"
  description = "Environment type: d=dev, t=test, p=prod"
  type        = string
}

variable "avi_l7_network" {
  default = "10.xx.xx.xx/22"
  description = "Avi Layer-7 network for ingress"
  type        = string  
}

variable "avi_l7_network_cidr" {
  default = "10.xx.xx.xx/28"
  description = "Avi Layer-7 cidr network for ingress"
  type        = string
}

# variable "TMC_ENDPOINT" {
#   description = "TMC Endpoints"
#   type        = string
# }

# variable "VMW_CLOUD_ENDPOINT" {
#   description = "VMW cloud Endpoints"
#   type        = string
# }
