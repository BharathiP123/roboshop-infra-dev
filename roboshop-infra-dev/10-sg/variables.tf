variable "projectname" {
    type = string
    default = "roboshop"

  
}

variable "environment" {
    type = string
    default = "dev"
  
}

variable "sg_names" {
        # databases
        default = ["mongodb", "redis", "mysql", "rabbitmq",
        # backend
        "catalogue", "user", "cart", "shipping", "payment",
        # frontend
        "frontend",
        # bastion
        "bastion",
        # frontend load balancer
        "frontend_alb",
        #backend alb
        "backend_alb"
        ]
}

variable "sg_tags" {
    default = {
    DontDelete = true
    Name = "sg"
}
}

