# OCI IAM Users Groups Module Example

## Introduction

This example shows how to provision one compartment, one group, 2 users part of the group, 1 dynamic groups and a policy using the artifacts previously created.
This is done by instantiating the module twice - such as the output from the 1st instantiation can be used as input for the 2nd instantiation.

The following resources are created in this example:

* One compartment
* One Group
* Two users
* One Dynamic Group
* One policy

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
```

Edit your `iam.auto.tfvars` file:

```
# IAM Config Variable

iam_config = {
  default_compartment_id = "<default_compartment_id>"
  default_defined_tags   = {}
  default_freeform_tags  = {}
  compartments = {
    compartment_1 = {
      description    = "Test Compartment 1"
      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = null
      freeform_tags  = null
    }
  }
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
  dynamic_groups = {
    dynamic_group_1 = {
      compartment_id = "<specific_compartment_ocid>"
      description    = "Test Dynamic Group 1"
      instance_ids   = ["ocid1.instance.oc1.phx.xxxxxx"]
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
    }
    dynamic_group_2 = {
      compartment_id = "<specific_compartment_ocid>"
      description    = "Test Dynamic Group 2"
      instance_ids   = ["ocid1.instance.oc1.phx.yyyyyyy", "ocid1.instance.oc1.phx.zzzzz"]
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
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
