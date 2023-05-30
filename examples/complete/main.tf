provider "sbercloud" {
  auth_url = "https://iam.ru-moscow-1.hc.sbercloud.ru/v3"
  region   = "ru-moscow-1"
}

module "vpc" {
  source = "../../"

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

      vip_routes     = []
      ecs_routes     = []
      eni_routes     = []
      nat_routes     = []
      peering_routes = []
      vpn_routes     = []
      dc_routes      = []
      cc_routes      = []

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

}