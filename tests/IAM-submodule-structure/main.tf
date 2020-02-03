# Copyright (c) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


locals {
  iam_construct_config = {
    default_compartment_id = "ocid1.tenancy.oc1..aaaaaaaaa3qmjxr43tjexx75r6gwk6vjw22ermohbw2vbxyhczksgjir7xdq"
    default_defined_tags   = {}
    default_freeform_tags  = null
    compartments           = null
    /*
    compartments = {
      test_compartment_1 = {
        description    = "Test Compartment 1"
        compartment_id = "ocid1.tenancy.oc1..aaaaaaaaa3qmjxr43tjexx75r6gwk6vjw22ermohbw2vbxyhczksgjir7xdq"
        defined_tags   = null
        freeform_tags  = null
      }
    }*/
    groups_users = {
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
    }
    dynamic_groups = {
      dynamic_group_1 = {
        compartment_id = null
        description    = "Test Dynamic Group 1"
        instance_ids   = ["ocid1.instance.oc1.phx.testinstance1"]
        defined_tags   = {}
        freeform_tags  = {}
      }
      dynamic_group_2 = {
        compartment_id = null
        description    = "Test Dynamic Group 2"
        instance_ids   = ["ocid1.instance.oc1.phx.testinstance2", "ocid1.instance.oc1.phx.testinstance3"]
        defined_tags   = {}
        freeform_tags  = null
      }
    }
  }
}
module "oci_iam_compartments" {

  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-iam-compartments.git?ref=v0.1.9"

  providers = {
    oci.oci_home = "oci.home"
  }
  compartments_config = {
    default_compartment_id = local.iam_construct_config.default_compartment_id
    default_defined_tags   = local.iam_construct_config.default_defined_tags
    default_freeform_tags  = local.iam_construct_config.default_freeform_tags
    compartments           = local.iam_construct_config.compartments
  }
}

module "oci_iam_users_groups" {

  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-iam-users-groups.git?ref=v0.1.10"

  providers = {
    oci.oci_home = "oci.home"
  }

  groups_users_config = {
    default_compartment_id = local.iam_construct_config.default_compartment_id
    default_defined_tags   = local.iam_construct_config.default_defined_tags
    default_freeform_tags  = local.iam_construct_config.default_freeform_tags
    groups                 = local.iam_construct_config.groups_users.groups
    users                  = local.iam_construct_config.groups_users.users
  }
}

module "oci_iam_dynamic_groups" {

  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-iam-dynamic-groups.git?ref=v0.1.9"

  providers = {
    oci.oci_home = "oci.home"
  }

  dynamic_groups_config = {
    default_compartment_id = local.iam_construct_config.default_compartment_id
    default_defined_tags   = local.iam_construct_config.default_defined_tags
    default_freeform_tags  = local.iam_construct_config.default_freeform_tags
    dynamic_groups         = local.iam_construct_config.dynamic_groups
  }
}

module "oci_iam_policies" {

  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-iam-policies.git?ref=v0.1.11"

  providers = {
    oci.oci_home = "oci.home"
  }

  # Policies
  policies_config = {
    default_compartment_id = local.iam_construct_config.default_compartment_id
    default_defined_tags   = local.iam_construct_config.default_defined_tags
    default_freeform_tags  = local.iam_construct_config.default_freeform_tags
    policies = {
      policy_1 = {
        compartment_id = null
        description    = "Test Policy 1"
        statements = ["Allow dynamic-group ${module.oci_iam_dynamic_groups.dynamic_groups[keys(module.oci_iam_dynamic_groups.dynamic_groups)[0]].name} to manage virtual-network-family in tenancy",
        "Allow group ${module.oci_iam_users_groups.groups_and_users.groups[keys(module.oci_iam_users_groups.groups_and_users.groups)[0]].name} to manage all-resources in tenancy"]
        defined_tags  = {}
        freeform_tags = null
        version_date  = null
      }
    }
  }
}

