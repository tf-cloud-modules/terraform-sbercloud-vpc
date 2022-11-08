# terraform-sbercloud-vpc
Sbercloud VPC Terraform module

## Provider configuration
```hcl
provider "sbercloud" {
  auth_url = "https://iam.ru-moscow-1.hc.sbercloud.ru/v3"
  region   = "ru-moscow-1"
}
```

## Usage
```hcl
module "vpc" {
    source  = "tf-cloud-modules/vpc/sbercloud"

    name = "tf-vpc-test"
    cidr =  "10.0.0.0/16"

    tags = {
    env = "test"
    }
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_sbercloud"></a> [sbercloud](#requirement\_sbercloud) | >= 1.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_sbercloud"></a> [sbercloud](#provider\_sbercloud) | 1.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [sbercloud_vpc.this](https://registry.terraform.io/providers/sbercloud-terraform/sbercloud/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | Specifies the range of available subnets in the VPC. | `string` | n/a | yes |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Controls if VPC should be created. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Specifies supplementary information about the VPC. | `string` | `null` | no |
| <a name="input_enterprise_project_id"></a> [enterprise\_project\_id](#input\_enterprise\_project\_id) | Specifies the enterprise project id of the VPC. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the VPC. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Specifies the region in which to create the VPC. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cidr"></a> [cidr](#output\_cidr) | Specifies the range of available subnets in the VPC. |
| <a name="output_enterprise_project_id"></a> [enterprise\_project\_id](#output\_enterprise\_project\_id) | Specifies the enterprise project id of the VPC. |
| <a name="output_id"></a> [id](#output\_id) | The VPC ID in UUID format. |
| <a name="output_name"></a> [name](#output\_name) | Specifies the name of the VPC. |
| <a name="output_region"></a> [region](#output\_region) | Specifies the region in which to create the VPC. |
<!-- END_TF_DOCS -->