module "components" {
    for_each = var.components
    source = "git::https://github.com/BharathiP123/roboshop-infra-dev.git//terraform-roboshop-component?ref=main"
    compnent = each.key
    rule_priority = each.value.rule_priority
      
}