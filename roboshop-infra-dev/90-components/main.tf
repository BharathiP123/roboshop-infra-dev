module "components" {
    for_each = var.components
    source = "../../../terraform-roboshop-component"
    compnent = each.key
    rule_priority = each.value.rule_priority
      
}