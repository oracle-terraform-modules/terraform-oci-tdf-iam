# Copyright (c) 2020, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl..


# tenancy details
variable "tenancy_id" {}
variable "user_id" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "iam_construct_config" {
  type = object({
    default_compartment_id = string,
    default_defined_tags   = map(string),
    default_freeform_tags  = map(string),
    compartments = map(object({
      description    = string,
      compartment_id = string,
      defined_tags   = map(string),
      freeform_tags  = map(string)
    })),
    groups_users = object({
      groups = map(object({
        compartment_id = string,
        defined_tags   = map(string),
        freeform_tags  = map(string),
        description    = string
      })),
      users = map(object({
        compartment_id = string,
        defined_tags   = map(string),
        freeform_tags  = map(string),
        description    = string,
        email          = string,
        groups         = list(string)
      }))
    }),
    dynamic_groups = map(object({
      compartment_id = string,
      description    = string,
      instance_ids   = list(string),
      defined_tags   = map(string),
      freeform_tags  = map(string)
  })) })
}