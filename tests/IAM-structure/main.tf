# Copyright (c) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.



locals {
  iam_config = {
    default_compartment_id = var.compartment_id
    default_defined_tags   = {}
    default_freeform_tags  = null
    /*compartments = {
      compartment_1 = {
        description    = "Test Compartment 1"
        compartment_id = null
        defined_tags   = null
        freeform_tags  = null
      }
    }*/
    compartments = null
    groups = {
      group_1 = {
        compartment_id = null
        defined_tags   = {}
        freeform_tags  = null
        description    = "Test Group 1"
      }
    }
    users = {
      test_user_1 = {
        compartment_id = null
        defined_tags   = {}
        freeform_tags  = {}
        description    = "Test user 1"
        email          = "test_user_1@gmail.com"
        groups         = ["group_1"]
      }
      test_user_2 = {
        compartment_id = null
        defined_tags   = {}
        freeform_tags  = null
        description    = "Test user 2"
        email          = "test_user_2@yahoo.com"
        groups         = ["group_1"]
      }
    }
    dynamic_groups = {
      dynamic_group_1 = {
        compartment_id = null
        description    = "Test Dynamic Group 1"
        instance_ids   = ["ocid1.instance.oc1.phx.testinstance"]
        defined_tags   = {}
        freeform_tags  = null
      }
    }
    policies = null // see module instantiation
  }
  policies = {
    policy_1 = {
      compartment_id = null
      description    = "Test Policy 1"
      statements = ["Allow dynamic-group ${module.oci_iam_no_policies.iam_config.dynamic_groups[keys(module.oci_iam_no_policies.iam_config.dynamic_groups)[0]].name} to manage virtual-network-family in tenancy",
      "Allow group ${module.oci_iam_no_policies.iam_config.groups_and_users.groups[keys(module.oci_iam_no_policies.iam_config.groups_and_users.groups)[0]].name} to manage all-resources in tenancy"]
      defined_tags  = {}
      freeform_tags = null
      version_date  = null
    }
  }
  iam_config_with_policies = {
    default_compartment_id = local.iam_config.default_compartment_id
    default_defined_tags   = local.iam_config.default_defined_tags
    default_freeform_tags  = local.iam_config.default_freeform_tags
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

  iam_config = local.iam_config
}

module "oci_iam_with_policies" {

  source = "../../"

  providers = {
    oci.oci_home = "oci.home"
  }

  iam_config = local.iam_config_with_policies
}

