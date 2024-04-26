locals {
  tkgs_cluster_variables = {    
    "defaultStorageClass" : var.storage_class,
    "defaultVolumeSnapshotClass" : "volumesnapshotclass-delete",
    "nodePoolLabels" : [
 
    ],
    "nodePoolVolumes" : [
      {
        "capacity" : {
          "storage" : var.storage_capacity
        },
        "mountPath" : "/var/lib/containerd",
        "name" : "containerd",
        "storageClass" : var.storage_class
      },
      {
        "capacity" : {
          "storage" : var.storage_capacity
        },
        "mountPath" : "/var/lib/kubelet",
        "name" : "kubelet",
        "storageClass" : var.storage_class
      }
    ],
    "ntp" : var.ntp,
    "storageClass" : var.storage_class,
    "storageClasses" : [
      var.storage_class
    ],
    "vmClass" : "best-effort-standard"
  }
 
  tkgs_nodepool_a_overrides = {
    "nodePoolLabels" : [
      {
        "key" : "env",
        "value" : "prod"
      }
    ],
    "storageClass" : var.storage_class,
    "vmClass" : "best-effort-standard"
  }
}
 
# Create Tanzu Mission Control Tanzu Kubernetes Grid Service workload cluster entry
provider "tanzu-mission-control" {
  endpoint            = var.endpoint            # optionally use TMC_ENDPOINT env var
  vmw_cloud_api_token = var.vmw_cloud_api_token # optionally use VMW_CLOUD_API_TOKEN env var
 
  # if you are using dev or different csp endpoint, change the default value below
  # for production environments the vmw_cloud_endpoint is console.cloud.vmware.com
  # vmw_cloud_endpoint = "console.cloud.vmware.com" or optionally use VMW_CLOUD_ENDPOINT env var
}
 
# Configure NSX-T provider
/* provider "nsxt" {
  username             = var.nsxt_username
  password             = var.nsxt_password
  host                 = var.nsxt_host
  allow_unverified_ssl = var.allow_unverified_ssl
} */
 
# Configure VMware vSphere provider
provider "vsphere" {
  user                 = var.vcenter_username
  password             = var.vcenter_password
  vsphere_server       = var.vcenter_host
  allow_unverified_ssl = var.allow_unverified_ssl
}

resource "tanzu-mission-control_tanzu_kubernetes_cluster" "vcf-tkgs-tmc-cluster" {
  management_cluster_name = var.management_cluster_name
  provisioner_name        = var.provisioner_name
  name                    = var.cluster_name
  meta {
    labels = { "env" : var.environment } // any specific labels to add to the cluster???
  }
 
  spec {
    cluster_group_name = var.cluster_group // Default: false 
      topology {
        version           = var.tkgs_version 
        cluster_class     = "tanzukubernetescluster"
        cluster_variables = jsonencode(local.tkgs_cluster_variables)
        control_plane {          
	  replicas = 3
          os_image {
            name    = "photon"
            version = "3"
            arch    = "amd64"
          }

        #   }
        }
        nodepool {
          name        = "nodepool"
          description = "worker nodes"
          spec {
            os_image {
              name    = "photon"
              version = "3"
              arch    = "amd64"
            }
            worker_class = "node-pool"
            replicas = 2
            overrides    = jsonencode(local.tkgs_nodepool_a_overrides)

          }
        }
        network {
          pod_cidr_blocks = [
          "172.20.0.0/16",
          ]
          service_cidr_blocks = [
          "10.96.0.0/16",
          ]        
        }   
    }
  }
  timeout_policy {
    timeout             = 15
    wait_for_kubeconfig = true
    fail_on_timeout     = true
  }
}
