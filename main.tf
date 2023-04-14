terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}


resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "k8s"
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

resource "local_file" "k8s" {
    context = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
    filename = "kubeconfig.yml" 
}