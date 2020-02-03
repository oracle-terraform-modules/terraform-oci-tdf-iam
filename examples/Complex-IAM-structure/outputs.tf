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