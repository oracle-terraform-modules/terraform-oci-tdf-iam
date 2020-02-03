# Copyright (c) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.




module "oci_iam_compartments" {

  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-iam-compartments.git?ref=v0.1.9"

  providers = {
    oci.oci_home = "oci.home"
  }
  compartments_config = {
    default_compartment_id = var.iam_construct_config.default_compartment_id
    default_defined_tags   = var.iam_construct_config.default_defined_tags
    default_freeform_tags  = var.iam_construct_config.default_freeform_tags
    compartments           = var.iam_construct_config.compartments
  }
}

module "oci_iam_users_groups" {

  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-iam-users-groups.git?ref=v0.1.10"

  providers = {
    oci.oci_home = "oci.home"
  }

  groups_users_config = {
    default_compartment_id = var.iam_construct_config.default_compartment_id
    default_defined_tags   = var.iam_construct_config.default_defined_tags
    default_freeform_tags  = var.iam_construct_config.default_freeform_tags
    groups                 = var.iam_construct_config.groups_users.groups
    users                  = var.iam_construct_config.groups_users.users
  }
}

module "oci_iam_dynamic_groups" {

  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-iam-dynamic-groups.git?ref=v0.1.9"

  providers = {
    oci.oci_home = "oci.home"
  }

  dynamic_groups_config = {
    default_compartment_id = var.iam_construct_config.default_compartment_id
    default_defined_tags   = var.iam_construct_config.default_defined_tags
    default_freeform_tags  = var.iam_construct_config.default_freeform_tags
    dynamic_groups         = var.iam_construct_config.dynamic_groups
  }
}

module "oci_iam_policies" {

  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-iam-policies.git?ref=v0.1.11"

  providers = {
    oci.oci_home = "oci.home"
  }

  # Policies
  policies_config = {
    default_compartment_id = var.iam_construct_config.default_compartment_id
    default_defined_tags   = var.iam_construct_config.default_defined_tags
    default_freeform_tags  = var.iam_construct_config.default_freeform_tags
    policies = {
      policy_1 = {
        compartment_id = module.oci_iam_compartments.compartments_config[keys(module.oci_iam_compartments.compartments_config)[0]].id
        description    = "Test Policy 1"
        statements = ["Allow dynamic-group ${module.oci_iam_dynamic_groups.dynamic_groups[keys(module.oci_iam_dynamic_groups.dynamic_groups)[0]].name} to manage virtual-network-family in compartment ${module.oci_iam_compartments.compartments_config[keys(module.oci_iam_compartments.compartments_config)[0]].name}",
        "Allow group ${module.oci_iam_users_groups.groups_and_users.groups[keys(module.oci_iam_users_groups.groups_and_users.groups)[0]].name} to manage all-resources in compartment ${module.oci_iam_compartments.compartments_config[keys(module.oci_iam_compartments.compartments_config)[0]].name}"]
        defined_tags  = {}
        freeform_tags = null
        version_date  = null
      }
    }
  }
}

