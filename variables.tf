
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
  sensitive   = true
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

variable "entitlement_key" {
  type        = string
  description = "The entitlement key required to access Cloud Pak images"
  sensitive   = true
}

#Module Specific extension
variable "is_ace_dash_required_dedicated_ns" {
  type = bool
  description = "If ACE Dashboard instance need to be deployed in dedicated namespace"
  default = false

  
}
variable "ace_dash_instance_namespace" {
  type = string
  description = "It is beeter to manage ACE Dashboard instance workload in a dedicated namespace"
  default = "gitops-cp-ace-dashboard"
}

variable "ace_version" {
  type        = string
  description = "The version of the ACE Dashboard should be installed"
  default     = ""
}

variable "license" {
  type        = string
  description = "The license string that should be used for the instance"
  default     = ""
}

variable "license_use" {
  type        = string
  description = "The possible values are CloudPakForIntegrationNonProduction or CloudPakForIntegrationProductionn"
  default     = ""
}


#If ACE Dashboad Instance needed to be overridden then use this
variable "ace_dash_instance_name" {
  type = string
  description = "If ACE Dashboard instance name needed to be overridden"
  default = ""
  
}
#If ACE Dashboad Instance needed to be overridden then use this
variable "storage_class_name" {
  type = string
  description = "RWX Accessmode supported Storageclass is required "
  default = "portworx-db2-rwo-sc"
  
}