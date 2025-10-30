module "vpc" {
    source = "git::https://github.com/BharathiP123/terraform-modules.git//vpc-module"
    vpc_cidr = var.vpccidr
    project = var.porojectname
    environment = var.envname
    vpc_tags = var.vpctags
    public_cidrs = var.publiccidr
    public_tags = var.publictags
    private_cidrs = var.privatecidr
    private_tags = var.privatetags
    database_cidrs = var.databasecidr
    database_tags = var.databasetags
    database_routetable_tags = var.database_route_tags
    private_routetable_tags = var.private_route_tags
    public_routetable_tags = var.public_route_tags
    nat_tags = var.nat_tags_private
    eip_tags = var.eip_tags_nat
    

}
