# Copyright (c) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


# IAM config

iam_config = {
  default_tenancy_compartment_id = "<default_compartment_ocid>"
  default_defined_tags           = "<default_defined_tags>"
  default_freeform_tags          = "<default_freeform_tags>"
  compartments                   = null
  groups                         = null
  users                          = null
  dynamic_groups                 = null
  policies = {
    policy_1 = {
      description    = "Test Policy 1"
      statements     = ["<statement-1>", "<statement-2>"]
      version_date   = null
      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
    }
    policy_2 = {
      description    = "Test Policy 2"
      statements     = ["<statement-1>"]
      version_date   = null
      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<default_freeform_tags>"
    }
  }
}