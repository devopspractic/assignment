resource "kubernetes_persistent_volume" "volume_mount" {
  metadata {
    name = "volume_mount"
  }
  spec {
    capacity {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "example"
    aws_elastic_block_store {
      fs_type = "nfs"
      volume_id = modules.efs.aws_efs_file_system
      read_only = false
    }
  }
}
resource "kubernetes_persistent_volume_claim" "volume_claim" {
  metadata {
    name = "volume_claim"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests {
        storage = "1Gi"
      }
    }
    storage_class_name = "example"
  }
}
