locals {

  # If decided to create the ACE Dashboard instance in the dedicated namepace 
  namespace =  var.namespace
  
  name          = "gitops-cp-ace-dashboard"
  
   
  base_name          = "ibm-ace"
  
  # If the name of an ACE Dashboard is overridden then choose the overridden value
  instance_name =  "${local.base_name}-dashboard"

  chart_name="ibm-ace-dashboard" 
  instance_chart_dir = "${path.module}/charts/${local.chart_name}"
  yaml_dir           = "${path.cwd}/.tmp/${local.name}/chart/${local.chart_name}"
  

  service_url   = "http://${local.name}.${local.namespace}"

  values_content = {
    "ibm_ace_dashboard" = {
      name=local.instance_name
      license={
        accept = true
        license=var.license
        use=var.license_use
      }
      pod={
        containers={
            content-server={
              resources={
                limits={
                  cpu="1"
                  memory="512Mi"
                }
                requests={
                  cpu="50m"
                  memory="50Mi"
                }
              }
            }
          
            control-ui={
              resources={
                limits={
                  cpu="1"
                  memory="512Mi"
                }
                requests={
                  cpu="50m"
                  memory="50Mi"
                }
              }
            }            
         }
      }
      storage={
        size="5Gi"
        type="persistent-claim"
        class=var.storage_class_name
      }
      useCommonServices="true"
      version=var.ace_version
    }
  }
  layer = "services"
  type  = "base"
  application_branch = "main"
  values_file = "values.yaml"      


  layer_config = var.gitops_config[local.layer]
}


# #ACE Dashboard instance namespace creation
# module "ace_dash_instance_ns" {
#     source = "github.com/cloud-native-toolkit/terraform-gitops-namespace.git"

#   gitops_config = var.gitops_config
#   git_credentials = var.git_credentials
#   name = local.namespace
  
# }



module pull_secret {
  source = "github.com/cloud-native-toolkit/terraform-gitops-pull-secret"

  #depends_on = [module.ace_dash_instance_ns]

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  server_name = var.server_name
  kubeseal_cert = var.kubeseal_cert
  #namespace = var.namespace
  namespace=local.namespace
  docker_username = "cp"
  docker_password = var.entitlement_key
  docker_server   = "cp.icr.io"
  secret_name     = "ibm-entitlement-key"
}


resource null_resource create_yaml {
  provisioner "local-exec" {
    
    command = "${path.module}/scripts/create-yaml.sh '${local.instance_name}' '${local.instance_chart_dir}' '${local.yaml_dir}' '${local.values_file}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.values_content)
    }
  }
}

resource gitops_module setup_gitops {
  depends_on = [null_resource.create_yaml]

  name = local.name
  namespace = local.namespace
  content_dir = local.yaml_dir
  server_name = var.server_name
  layer = local.layer
  type = local.type
  branch = local.application_branch
  config = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
}
