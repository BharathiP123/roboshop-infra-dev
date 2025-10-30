variable "vpccidr" {
  type = string
}

variable "porojectname" {
  type = string
}

variable "envname" {
  type = string
}

variable "vpctags" {
    default = {
        Purpose = "vpc-created-using-modules"
        DontDelete = true
    }
  
}

variable "publiccidr" {
  type = list
}

variable "igwtags" {
  default = {
    Purpose = "createdforcommunicatewthoutsideworld"
  }
}

variable "publictags" {
    type = map
    default = {
        Created = "publicsubnets"
    }
  
}

variable "privatetags" {
    type = map
    default = {
        Created = "privatesubnets"
    }
  
}
variable "databasetags" {
    type = map
    default = {
        Created = "databasesubnet"
    }
  
}

variable "privatecidr" {
  type = list
}
variable "databasecidr" {
  type = list
}

variable "public_route_tags" {
    default = {
        Route = "public"
    }
}


variable "private_route_tags" {
    default = {
        Route = "private"
    }
}


variable "database_route_tags" {
   default = {
    Route = "database"
   }
}

variable "eip_tags_nat"{
    
    default = {
        Elp = "true"
    }
}

variable "nat_tags_private"{

    default = {
        Nategateway = "privatesubnetegress"
    }
}