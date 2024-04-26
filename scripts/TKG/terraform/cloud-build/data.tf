data "vsphere_datacenter" "datacenter" {
  name = "datacenter"
}

/* data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name = var.east_west_transport_zone_name
}

data "nsxt_policy_transport_zone" "vlan_tz" {
  display_name = "nsx-vlan-transportzone"
}

data "nsxt_policy_edge_cluster" "ec" {
  display_name = var.nsxt_edge_cluster_name
}

data "nsxt_policy_tier0_gateway" "nsxt_active_t0_gateway" {
  display_name = var.nsxt_active_t0_gateway_name
} */

data "vsphere_datastore" "vsan_datastore" {
  name          = "vsan_datastore"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
