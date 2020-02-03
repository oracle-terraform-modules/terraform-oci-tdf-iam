# Copyright (c) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


locals {
  policies = {
    policy_1 = {
      compartment_id = module.oci_iam_no_policies.iam_config.compartments[keys(module.oci_iam_no_policies.iam_config.compartments)[0]].id
      description    = "Test Policy 1"
      statements = ["Allow dynamic-group ${module.oci_iam_no_policies.iam_config.dynamic_groups[keys(module.oci_iam_no_policies.iam_config.dynamic_groups)[0]].name} to manage virtual-network-family in compartment ${module.oci_iam_no_policies.iam_config.compartments[keys(module.oci_iam_no_policies.iam_config.compartments)[0]].name}",
      "Allow group ${module.oci_iam_no_policies.iam_config.groups_and_users.groups[keys(module.oci_iam_no_policies.iam_config.groups_and_users.groups)[0]].name} to manage all-resources in compartment ${module.oci_iam_no_policies.iam_config.compartments[keys(module.oci_iam_no_policies.iam_config.compartments)[0]].name}"]
      defined_tags  = {}
      freeform_tags = null
      version_date  = null
    }
  }
  iam_config_with_policies = {
    default_compartment_id = var.iam_config.default_compartment_id
    default_defined_tags   = var.iam_config.default_defined_tags
    default_freeform_tags  = var.iam_config.default_freeform_tags
    compartments           = null
    groups                 = null
    users                  = null
    dynamic_groups         = null
    policies               = local.policies
  }
}

module "oci_iam_no_policies" {

  source = "../../"

  providers = {
    oci.oci_home = "oci.home"
  }

  iam_config = var.iam_config
}

module "oci_iam_with_policies" {

  source = "../../"

  providers = {
    oci.oci_home = "oci.home"
  }

  iam_config = local.iam_config_with_policies
}

