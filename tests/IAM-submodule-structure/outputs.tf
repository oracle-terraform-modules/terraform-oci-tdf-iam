# Copyright (c) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


#########################
## IAM Construct
#########################

output "iam_construct" {
  description = "IAM Construct:"
  value = {
    compartments        = module.oci_iam_compartments.compartments_config
    groups_and_users    = module.oci_iam_users_groups.groups_and_users
    dynamic_groups      = module.oci_iam_dynamic_groups.dynamic_groups
    policies            = module.oci_iam_policies.policies
    tenancy_home_region = [for i in data.oci_identity_region_subscriptions.this.region_subscriptions : i.region_name if i.is_home_region == true][0]
  }
}

output "iam_compartments" {
  description = "IAM Compartments:"
  value       = module.oci_iam_compartments.compartments_config

}

output "iam_groups" {
  description = "IAM Groups:"
  value       = module.oci_iam_users_groups.groups_and_users.groups
}

output "iam_users" {
  description = "IAM Users"
  value = {
    users = { for user in module.oci_iam_users_groups.groups_and_users.users : user.name => {
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

output "iam_policies" {
  description = "IAM Policies:"
  value       = module.oci_iam_policies.policies
}

output "iam_dynamic_groups" {
  description = "IAM Dynamic Groups:"
  value       = module.oci_iam_dynamic_groups.dynamic_groups
}