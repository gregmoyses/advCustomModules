locals {
  sub-name = lower(replace(var.subscription-name, "/[^A-Za-z]/", ""))
  customer-code = lower(var.customer-code)
  location = lower(replace(var.location, "/[^A-Za-z]/", ""))
  tags = merge([local.default-tags,var.tags]...)
  default-tags = {
    "Deployed-Via" = "terraform"
  }
}