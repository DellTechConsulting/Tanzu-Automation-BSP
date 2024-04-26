# T1 Gateway, Segment, and SNAT for Avi-VIP
/* resource "nsxt_policy_tier1_gateway" "avi-namespace-app0001-T1" {
  nsx_id                    = "avi-${var.provisioner_name}-T1"
  display_name              = "avi-${var.provisioner_name}-T1"
  description               = "Tier-1 Gateway for Override Avi-VIP (Layer 7) Network"
  edge_cluster_path         = data.nsxt_policy_edge_cluster.ec.path
  tier0_path                = data.nsxt_policy_tier0_gateway.nsxt_active_t0_gateway.path
  route_advertisement_types = ["TIER1_STATIC_ROUTES", "TIER1_CONNECTED", "TIER1_NAT", "TIER1_LB_VIP", "TIER1_LB_SNAT", "TIER1_DNS_FORWARDER_IP", "TIER1_IPSEC_LOCAL_ENDPOINT"]
  pool_allocation           = "ROUTING"
}

resource "nsxt_policy_segment" "avi-namespace-app0001-L7-VIP" {
  nsx_id              = "avi-${var.provisioner_name}-L7-VIP"
  display_name        = "avi-${var.provisioner_name}-L7-VIP"
  description         = "CIDR for Override Avi-VIP (Layer 7) Network"
  connectivity_path   = nsxt_policy_tier1_gateway.avi-namespace-app0001-T1.path
  transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path

  subnet {
    cidr = var.avi_vip_segment_cidr
  }
}

resource "nsxt_policy_nat_rule" "avi-tkgs-app0001-SNAT" {
  display_name        = "avi-${var.cluster_name}-SNAT"
  description         = "SNAT rule for traffic from the T1 to the Egress network"
  action              = "SNAT"
  gateway_path        = nsxt_policy_tier1_gateway.avi-namespace-app0001-T1.path
  logging             = false
  translated_networks = [var.avi_cluster_egress_snat_ip]
  rule_priority       = 1000
}

# Distributed Firewall Policy and Rules
resource "nsxt_policy_security_policy" "avi-tkgs-app0001" {
  display_name = "avi-${var.cluster_name}" # Update this per cluster
  description  = "Security Policy for AVI SEs to access the K8 nodes within the cluster"
  category     = "Infrastructure"
  locked       = false
  stateful     = true
  tcp_strict   = false
  scope        = [nsxt_policy_group.avi-tkgs-app0001-SNAT.path]

  rule {
    display_name       = "SEs to K8 nodes"
    source_groups      = [nsxt_policy_group.avi-tkgs-app0001-SNAT.path]
    destination_groups = [nsxt_policy_group.tanzu-namespace-network.path]
    action             = "ALLOW"
    logged             = false
  }
}

# source_group
resource "nsxt_policy_group" "avi-tkgs-app0001-SNAT" {
  display_name = "avi-${var.cluster_name}-SNAT" # Update this per cluster
  description  = "AVI SE SNAT"

  criteria {
    ipaddress_expression {
      ip_addresses = [var.avi_cluster_egress_snat_ip]
    }
  }
}

# destination_group
resource "nsxt_policy_group" "tanzu-namespace-network" {
  display_name = "tanzu-namespace-network-${var.cluster_name}"
  description  = "vSphere namespace network for cluster ${var.cluster_name}"

  criteria {
    ipaddress_expression {
      ip_addresses = [var.tanzu-namespace-network]
    }
  }
} */
