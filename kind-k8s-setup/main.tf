# Providers 
terraform {
  required_providers {
    kind = {
      source = "kyma-incubator/kind"
      version = "0.0.9"
    }
  }
}

provider "kind" {}



# Local Data
locals {

}

# Kind Init
resource "kind_cluster" "kind-base" {
  name = "kind-base"
  wait_for_ready = true
  kind_config  {
     kind = "Cluster"
     api_version = "kind.x-k8s.io/v1alpha4"
     networking {
        disable_default_cni = false
        pod_subnet = "192.168.0.0/16"
     }
     node {
        role = "control-plane"
        image = "kindest/node:v1.18.8"
     }
     node{
        role = "worker"
        image = "kindest/node:v1.18.8"
        kubeadm_config_patches = [
        <<-INTF
kind: JoinConfiguration
nodeRegistration:
    kubeletExtraArgs:
        node-labels: "deployment.group=infrastructure"
        INTF
        ]
         
     }
     

  }
}