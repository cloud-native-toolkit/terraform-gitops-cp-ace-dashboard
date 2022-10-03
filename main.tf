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


resource gitops_pull_secret cp_icr_io {
  name = "ibm-entitlement-key"
  namespace = local.namespace
  server_name = var.server_name
  branch = local.application_branch
  layer = local.layer
  credentials = yamlencode(var.git_credentials)
  config = yamlencode(var.gitops_config)
  kubeseal_cert = var.kubeseal_cert

  secret_name     = "ibm-entitlement-key"
  registry_server = "cp.icr.io"
  registry_username = "cp"
  registry_password = var.entitlement_key
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
