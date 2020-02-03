# Copyright (c) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.




# iam construct input variable 

iam_construct_config = {
  default_compartment_id = "<default compartment ocid>"
  default_defined_tags   = "<default defined tags>"
  default_freeform_tags  = "<default freeform tags>"
  compartments = {
    compartment_1 = {
      description    = "Test Compartment 1"
      compartment_id = "<specific compartment ocid>"
      defined_tags   = "<specific defined tags>"
      freeform_tags  = "<specific freeform tags>"
    }
    compartment_2 = {
      description    = "Test Compartment 2"
      compartment_id = "<specific compartment ocid>"
      defined_tags   = "<specific defined tags>"
      freeform_tags  = "<specific freeform tags>"
    }
  }
  groups_users = {
    groups = {
      group_1 = {
        compartment_id = "<specific_compartment_ocid>"
        defined_tags   = "<specific_defined_tags>"
        freeform_tags  = "<specific_freeform_tags>"
        description    = "Test Group 1"
      }
    }
    users = {
      test_user_1 = {
        compartment_id = "<specific_compartment_ocid>"
        defined_tags   = "<specific_defined_tags>"
        freeform_tags  = "<specific_freeform_tags>"
        description    = "Test user 1"
        email          = "test_user_1@gmail.com"
        groups         = ["group_1"]
      }
      test_user_2 = {
        compartment_id = "<specific_compartment_ocid>"
        defined_tags   = "<specific_defined_tags>"
        freeform_tags  = "<specific_freeform_tags>"
        description    = "Test user 2"
        email          = "test_user_2@yahoo.com"
        groups         = ["group_1"]
      }
    }
  }
  dynamic_groups = {
    dynamic_group_1 = {
      description    = "Test Dynamic Group 1"
      instance_ids   = ["ocid1.instance.oc1.phx.abxxxxxxxx"]
      compartment_id = "<specific compartment ocid>"
      defined_tags   = "<specific defined tags>"
      freeform_tags  = "<specific freeform tags>"
    }
    dynamic_group_2 = {
      description    = "Test Dynamic Group 2"
      instance_ids   = ["ocid1.instance.oc1.phx.abyhyyyyy", "ocid1.instance.oc1.phxzzzzzzz"]
      compartment_id = "<specific compartment ocid>"
      defined_tags   = "<specific defined tags>"
      freeform_tags  = "<specific freeform tags>"
    }
  }
}