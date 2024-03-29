# terraform-sbercloud-vpc
Sbercloud VPC Terraform module

## Features

- Create vpc, subnets, nat gateways, routes for subnet route tables
- Easy to use in other resources via outputs

## How to Configure Terraform for Sbercloud

- [Sbercloud Quickstart](https://cloud.ru/ru/docs/terraform/ug/topics/quickstart.html)
- Add environment variables for terraform authentication in Sbercloud

```
export SBC_ACCESS_KEY="xxxx-xxx-xxx"
export SBC_SECRET_KEY="xxxx-xxx-xxx"
```

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
    cidr = "10.0.0.0/16"

    azs = ["ru-moscow-1a", "ru-moscow-1b"]
    subnets = [
    {
        cidr       = "10.0.0.0/24"
        gateway_ip = "10.0.0.1"

        nat_gw = {
        spec = "1"
        }

        eip = {
        type        = "5_bgp"
        share_type  = "PER"
        size        = 1
        charge_mode = "traffic"
        }

        # vip_routes = [
        #   {
        #     destination = "192.168.100.0/24"
        #     nexthop     = "10.0.0.117"
        #     description = "test"
        #   }
        # ]

        ecs_routes     = []
        eni_routes     = []
        nat_routes     = []
        peering_routes = []
        vpn_routes     = []
        dc_routes      = []
        cc_routes      = []

        # existing_eip = "xxxx-xxx-xxx" # excludes eip creation and use existing one, has precedence over eip creation

    },
    {
        cidr       = "10.0.1.0/24"
        gateway_ip = "10.0.1.1"
    },
    ]

    dhcp_enable   = true
    primary_dns   = "100.125.13.59"
    secondary_dns = "8.8.8.8"

    tags = {
    env = "test"
    }

    # default_route_table_routes = [
    #   {
    #     destination = "10.0.x.x/0"
    #     type        = "xxx"
    #     nexthop     = "xxxxx-xxx-xxx"
    #   },
    # ]
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_sbercloud"></a> [sbercloud](#requirement\_sbercloud) | >= 1.9.0, < 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_sbercloud"></a> [sbercloud](#provider\_sbercloud) | 1.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [sbercloud_nat_gateway.this](https://registry.terraform.io/providers/sbercloud-terraform/sbercloud/latest/docs/resources/nat_gateway) | resource |
| [sbercloud_nat_snat_rule.this](https://registry.terraform.io/providers/sbercloud-terraform/sbercloud/latest/docs/resources/nat_snat_rule) | resource |
| [sbercloud_vpc.this](https://registry.terraform.io/providers/sbercloud-terraform/sbercloud/latest/docs/resources/vpc) | resource |
| [sbercloud_vpc_eip.snat](https://registry.terraform.io/providers/sbercloud-terraform/sbercloud/latest/docs/resources/vpc_eip) | resource |
| [sbercloud_vpc_route.default_route](https://registry.terraform.io/providers/sbercloud-terraform/sbercloud/latest/docs/resources/vpc_route) | resource |
| [sbercloud_vpc_route_table.subnet](https://registry.terraform.io/providers/sbercloud-terraform/sbercloud/latest/docs/resources/vpc_route_table) | resource |
| [sbercloud_vpc_subnet.this](https://registry.terraform.io/providers/sbercloud-terraform/sbercloud/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | A list of availability zones names or ids in the region | `list(string)` | `[]` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | Specifies the range of available subnets in the VPC. | `string` | n/a | yes |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Controls if VPC should be created. | `bool` | `true` | no |
| <a name="input_default_route_table_routes"></a> [default\_route\_table\_routes](#input\_default\_route\_table\_routes) | Configuration block of routes. | `list(any)` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | Specifies supplementary information about the VPC. | `string` | `null` | no |
| <a name="input_dhcp_enable"></a> [dhcp\_enable](#input\_dhcp\_enable) | Specifies whether the DHCP function is enabled for the subnet. | `bool` | `false` | no |
| <a name="input_dns_list"></a> [dns\_list](#input\_dns\_list) | Specifies the DNS server address list of a subnet. | `list(string)` | `null` | no |
| <a name="input_enterprise_project_id"></a> [enterprise\_project\_id](#input\_enterprise\_project\_id) | Specifies the enterprise project id of the VPC. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the VPC. | `string` | n/a | yes |
| <a name="input_primary_dns"></a> [primary\_dns](#input\_primary\_dns) | Specifies the IP address of DNS server 1 on the subnet. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Specifies the region in which to create the VPC. | `string` | `null` | no |
| <a name="input_secondary_dns"></a> [secondary\_dns](#input\_secondary\_dns) | Specifies the IP address of DNS server 2 on the subnet. | `string` | `null` | no |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | Explicit values to use in the name values on subnets. If empty, name values are generated. | `list(string)` | `[]` | no |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | List of subnet tags. | `map(string)` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of subnets inside the VPC | `any` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of common tags. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Existing VPC where resources will be created. | `string` | `null` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | List of VPC tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cidr"></a> [cidr](#output\_cidr) | Specifies the range of available subnets in the VPC. |
| <a name="output_enterprise_project_id"></a> [enterprise\_project\_id](#output\_enterprise\_project\_id) | Specifies the enterprise project id of the VPC. |
| <a name="output_id"></a> [id](#output\_id) | The VPC ID in UUID format. |
| <a name="output_name"></a> [name](#output\_name) | Specifies the name of the VPC. |
| <a name="output_region"></a> [region](#output\_region) | Specifies the region in which to create the VPC. |
| <a name="output_subnet_cidr_blocks"></a> [subnet\_cidr\_blocks](#output\_subnet\_cidr\_blocks) | List of cidrs of subnets |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | List of IDs of subnets |
<!-- END_TF_DOCS -->