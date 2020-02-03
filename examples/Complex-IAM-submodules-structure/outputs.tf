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