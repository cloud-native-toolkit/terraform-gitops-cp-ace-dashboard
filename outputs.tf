
output "name" {
  description = "The name of the module"
  value       = local.name
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "branch" {
  description = "The branch where the module config has been placed"
  value       = local.application_branch
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "namespace" {
  description = "The namespace where the module will be deployed"
  value       = local.namespace
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "server_name" {
  description = "The server where the module will be deployed"
  value       = var.server_name
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "layer" {
  description = "The layer where the module is deployed"
  value       = local.layer
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "type" {
  description = "The type of module where the module is deployed"
  value       = local.type
  depends_on  = [resource.gitops_module.setup_gitops]
}


# #Extension. During BillOfMaterial execution, There would be a singlenamespace where all the components will be created under that.
# # To isolate ACE Dashboard instance from the OOB Namespace, we are creating a new namespace
# output "ace_dash_instance_namespace" {
#   description = "The namespace where the ace-dashboard instance  deployed"
#   value       = local.namespace
#   depends_on  = [module.ace_dash_instance_ns.name]
# }