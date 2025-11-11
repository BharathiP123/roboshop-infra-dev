module "components" {
    source = "../terraform-roboshop-component"
    component = var.component
    priority  = var.rule_prioirity
      
}