locals {
  cluster_domain = "cluster.${var.cluster_name}.${var.base_domain}"
  worker_count   = sum([for v in var.worker_nodepools : v.count])
  worker_nodes = merge([
    for pool_index, nodepool in var.worker_nodepools : {
      for node_index in range(nodepool.count) :
      format("%s-%s-%s", pool_index, node_index, nodepool.name) => {
        index : node_index,
        nodepool_name : nodepool.name,
        type : nodepool.type,
        location : nodepool.location,
        image_id : nodepool.image_id
      }
    }
  ]...)
}
