# OCI IAM Policies Module Example

## Introduction


This example assists you in orchestrating the OCI IAM TF submodules into more complex functionality like creating compartments, users, groups, dynamic groups and policies that we will those IAM objects.


The following resources are created in this example:

* zero, one or multiple compartments
* 1 x group containing zero, one or multiple provisioned users
* zero, one or multiple dynamic groups
* zero, one or multiple policies

## Using this example
* Prepare one variable file named `terraform.tfvars` with the required IAM information. The contents of `terraform.tfvars` should look something like the following (or copy and re-use the contents of `terraform.tfvars.template`:

```
### TENANCY DETAILS

# Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)
tenancy_id="<tenancy OCID"
# Get this from OCI > Identity > Users (for your user account)
user_id="<user OCID>"

# the fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))
fingerprint="<PEM key fingerprint>"
# this is the full path on your local system to the private key used for the API key pair
private_key_path="<path to the private key that matches the fingerprint above>"

# region (us-phoenix-1, ca-toronto-1, etc)
region="<your region>"
```

* Set up the provider:

`providers.tf`:

```
provider "oci" {
  tenancy_ocid     = "${var.tenancy_id}"
  user_ocid        = "${var.user_id}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region           = "${var.region}"
}

provider "oci" {
  alias            = "home"
  tenancy_ocid     = "${var.tenancy_id}"
  user_ocid        = "${var.user_id}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region           = [for i in data.oci_identity_region_subscriptions.this.region_subscriptions : i.region_name if i.is_home_region == true][0]
}

data "oci_identity_region_subscriptions" "this" {
  tenancy_id = var.tenancy_id
}
```
`main.tf`:

```
// Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.


module "oci_iam_compartments" {

  source = "git::git@orahub.oraclecorp.com:dev-sdf-ateam/terraform-oci-tdf-iam-compartments.git?ref=v0.1.3"

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

  source = "git::git@orahub.oraclecorp.com:dev-sdf-ateam/terraform-oci-tdf-iam-users-groups.git?ref=v0.1.4"

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

  source = "git::git@orahub.oraclecorp.com:dev-sdf-ateam/terraform-oci-tdf-iam-dynamic-groups.git?ref=v0.1.3"

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

  source = "git::git@orahub.oraclecorp.com:dev-sdf-ateam/terraform-oci-tdf-iam-policies.git?ref=v0.1.5"

  providers = {
    oci.oci_home = "oci.home"
  }

  # Policies
  policies_config = {
    default_tenancy_compartment_id = var.iam_construct_config.default_compartment_id
    default_defined_tags           = var.iam_construct_config.default_defined_tags
    default_freeform_tags          = var.iam_construct_config.default_freeform_tags
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
```

Edit your `iam.auto.tfvars` file:

```
# IAM Config Variable

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
```

Then apply the example using the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply
```
