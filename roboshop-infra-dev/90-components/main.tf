module "components" {
    for_each = var.components
    source = "https://github.com/BharathiP123/terraform-roboshop-component.git?ref=main"
    compnent = each.key
    rule_priority = each.value.rule_priority
      
}