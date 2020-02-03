# Copyright (c) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.



#########################
## IAM Config
#########################

output "iam_config_no_policies" {
  description = "iam config:"
  value = { iam_construct = module.oci_iam_no_policies.iam_config,
    home_region = [for i in data.oci_identity_region_subscriptions.this.region_subscriptions : i.region_name if i.is_home_region == true][0]
  }
}

output "iam_config_with_policies" {
  description = "iam config:"
  value = { iam_construct = module.oci_iam_with_policies.iam_config,
    home_region = [for i in data.oci_identity_region_subscriptions.this.region_subscriptions : i.region_name if i.is_home_region == true][0]
  }
}

#########################
## IAM Construct
#########################

output "iam_compartments" {
  description = "IAM Compartments:"
  value       = module.oci_iam_no_policies.iam_config.compartments

}

output "iam_groups" {
  description = "IAM Groups:"
  value       = module.oci_iam_no_policies.iam_config.groups_and_users.groups
}

output "iam_users" {
  description = "IAM Users"
  value = {
    users = { for user in module.oci_iam_no_policies.iam_config.groups_and_users.users : user.name => {
      name           = user.name,
      capabilities   = user.capabilities,
      compartment_id = user.compartment_id,
      defined_tags   = user.defined_tags,
      description    = user.description,
      email          = user.email,
      freeform_tags  = user.freeform_tags,
      id             = user.id,
      state          = user.state,
      groups         = { for group in user.groups : "group_name" => group.group_name... }
      }
    },
    tenancy_home_region = [for i in data.oci_identity_region_subscriptions.this.region_subscriptions : i.region_name if i.is_home_region == true][0]
  }
}

output "iam_dynamic_groups" {
  description = "IAM Dynamic Groups:"
  value       = module.oci_iam_no_policies.iam_config.dynamic_groups
}

output "iam_policies" {
  description = "IAM Policies:"
  value       = module.oci_iam_with_policies.iam_config.policies
}