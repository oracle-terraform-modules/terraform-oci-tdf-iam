# Oracle Cloud Infrastructure (OCI) IAM Module for Terraform

## Introduction

This module helps you orchestrating IAM resources into different IAM topologies.
  

## Solution

This module assists you in orchestrating the OCI IAM TF sub-modules into more complex functionality.

The module covers the following use case:

* Creating compartments, users, groups, dynamic groups and policies that we will those IAM objects.

## Prerequisites
This module does not create any dependencies or prerequisites :

Create the following before using this module: 
  * Required IAM construct to allow for the creation of resources

## Getting Started

One fully-functional examples have been provided in the `examples` directory.  

The scenarios covered in the examples section are:
* Creating compartments, users, groups, dynamic groups and policies that we will those IAM objects.  

## Accessing the Solution

This is a core service module that is foundational to many other resources in OCI, so there is really nothing to directly access.


## Module inputs

### Provider

This module supports a custom provider. With a custom provider, IAM resources must be deployed in your home tenancy, which might be different from the region that will contain other deployments. 

You'll be managing those providers in the tf automation projects where you reference this module.

Example:


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

The following IAM attributes are available in the the `terraform.tfvars` file:

```
### PRIMARY TENANCY DETAILS

# Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)
primary_tenancy_id="<tenancy OCID"
# Get this from OCI > Identity > Users (for your user account)
primary_user_id="<user OCID>"

# the fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))
primary_fingerprint="<PEM key fingerprint>"
# this is the full path on your local system to the private key used for the API key pair
primary_private_key_path="<path to the private key that matches the fingerprint above>"

# region (us-phoenix-1, ca-toronto-1, etc)
primary_region="<your region>"

### DR TENANCY DETAILS

# Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)
dr_tenancy_id="<tenancy OCID"
# Get this from OCI > Identity > Users (for your user account)
dr_user_id="<user OCID>"

# the fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))
dr_fingerprint="<PEM key fingerprint>"
# this is the full path on your local system to the private key used for the API key pair
dr_private_key_path="<path to the private key that matches the fingerprint above>"

# region (us-phoenix-1, ca-toronto-1, etc)
dr_region="<your region>"
```


### Compartments

Compartments input variable represents a map containing a collection of compartments. Each compartment object specifies the  attributes for a compartment, including the parent compartment.


**`oci_identity_compartment.compartments`**

| Attribute | Data Type | Required | Default Value | Valid Values | Description |
|---|---|---|---|---|---|
| provider | string | yes | "oci.oci_home"| string containing the name of the provider as defined by the automation that consumes this module | See the examples section in order to understand how to set the provider|
| count | number | yes | 0 | the number of resources to be created | the number of resources to be created |
| name | string | yes | "OCI-TF-Group" | string of the display name | Resource name |
| compartment\_id | string | yes | none | string of the parent compartment OCID | This is the OCID of the parent compartment |
| description | string | no | N/A (no default) | The provided description |
| define\_tags | map(string) | no | N/A (no default) | The defined tags.
| freeform\_tags| map(string) | no | N/A (no default) | The freeform\_tags.

### Users and Groups

**`oci_identity_group.groups`**

| Attribute | Data Type | Required | Default Value | Valid Values | Description |
|---|---|---|---|---|---|
| provider | string | yes | "oci.oci_home"| string containing the name of the provider as defined by the automation that consumes this module | See the examples section in order to understand how to set the provider|
| count | number | yes | 0 | the number of resources to be created | the number of resources to be created |
| name | string | yes | "OCI-TF-Group" | string of the display name | Resource name |
| compartment\_id | string | yes | none | string of the compartment OCID | This is the OCID of the compartment |
| description | string | no | N/A (no default) | The provided description |
| define\_tags | map(string) | no | N/A (no default) | The defined tags.
| freeform\_tags| map(string) | no | N/A (no default) | The freeform\_tags.

**`oci_identity_user.users`**
  

| Attribute | Data Type | Required | Default Value | Valid Values | Description |
|---|---|---|---|---|---|
| provider | string | yes | "oci.oci_home"| string containing the name of the provider as defined by the automation that consumes this module | See the examples section in order to understand how to set the provider| 
| count | number | yes | 0 | the number of resources to be created | the number of resources to be created |
| name | string | yes | "OCI-TF-User" | string of the display name | Resource name |
| compartment\_id | string | yes | none | string of the compartment OCID | This is the OCID of the compartment |
| description | string | no | N/A (no default) | The provided description |
| define\_tags | map(string) | no | N/A (no default) | The defined tags.
| freeform\_tags| map(string) | no | N/A (no default) | The freeform\_tags.
| email | string | no | N/A (no default) | The provided email |


**`oci_identity_user_group_membership.users_groups_membership`**
  

| Attribute | Data Type | Required | Default Value | Valid Values | Description |
|---|---|---|---|---|---|
| provider | string | yes | "oci.oci_home"| string containing the name of the provider as defined by the automation that consumes this module | See the examples section in order to understand how to set the provider | 
| count | number | yes | 0 | the number of resources to be created | the number of resources to be created |
| group\_id | string | yes | none | OCID of the group created above | OCID of the group created above|
| user\_id | string | yes | none | OCID of the user created above | OCID of the user created above |

### Dynamic_groups

Dynamic_groups input variable represents a map containing a collection of dynamic groups. Each dynamic group specifies the attributes for a dynamic group, including a list of corresponding instances.

**`oci_identity_dynamic_group.dynamic_groups`**

| Attribute | Data Type | Required | Default Value | Valid Values | Description |
|---|---|---|---|---|---|
| provider | string | yes | "oci.oci_home"| string containing the name of the provider as defined by the automation that consumes this module | See the examples section in order to understand how to set the provider|
| count | number | yes | 0 | the number of resources to be created | the number of resources to be created |
| name | string | yes | "OCI-TF-Group" | string of the display name | Resource name |
| compartment\_id | string | yes | none | string of the compartment OCID | This is the OCID of the compartment |
| matching\_rule | list(string) | yes | none | a list of strings containing the OCIDs of instances to be part of this dynamic group | Ta list of strings containing the OCIDs of instances to be part of this dynamic group |
| description | string | no | N/A (no default) | The provided description |
| define\_tags | map(string) | no | N/A (no default) | The defined tags.
| freeform\_tags| map(string) | no | N/A (no default) | The freeform\_tags.

### Policies

Policies input variable represents a map containing a collection of policies. Each policy specifies the attributes for a policy, including a list of statements.


**`oci_identity_policy.policies`**

| Attribute | Data Type | Required | Default Value | Valid Values | Description |
|---|---|---|---|---|---|
| provider | string | yes | "oci.oci_home"| string containing the name of the provider as defined by the automation that consumes this module | See the examples section in order to understand how to set the provider|
| count | number | yes | 0 | the number of resources to be created | the number of resources to be created |
| name | string | yes | "OCI-Policy" | string of the display name | Resource name |
| compartment\_id | string | yes | none | string of the compartment OCID | This is the OCID of the compartment |
| statements | list(string) | yes | none | a list of strings containing the policy statements | a list of strings containing the policy statements |
| description | string | no | N/A (no default) | The provided description |
| define\_tags | map(string) | no | N/A (no default) | The defined tags.
| freeform\_tags| map(string) | no | N/A (no default) | The freeform\_tags.
| version\_date| string | no | Current date | The version of the policy.


**Example**

The following example creates 1 compartment, 1 group, 2 users, and 2 dynamic groups
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

## Outputs

This module is returning 1 map object:

* `compartments` : Contains the details about each compartment
* `users_and_groups` : Contains the details about each group and its relationship with users
* `dynamic_groups` : Contains the details about each dynamic group
* `Policies` : Contains the details about each policy.

## Notes/Issues

## URLs

For Oracle Cloud Infrastructure IAM documentation, see https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Concepts/overview.htm
 
## Versions

This module has been developed and tested by running terraform on Oracle Linux Server release 7.7 

```
user-linux$ terraform --version
Terraform v0.12.19
+ provider.oci v3.58.0

```

## Contributing

This project is open source. Oracle appreciates any contributions that are made by the open source community.

## License

Copyright (c) 2020, Oracle and/or its affiliates.

Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

See [LICENSE](LICENSE) for more details.
