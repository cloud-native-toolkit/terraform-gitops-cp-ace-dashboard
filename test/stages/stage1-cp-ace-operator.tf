module "cp_ace_operator" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cp-app-connect.git"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  
  channel = module.cp4i-dependencies.ace.channel
  
  
}
