 
 terraform {
   ##Use for providing multiple providers
  required_providers {  
    aws = {
      source = "hashicorp/aws"
      version = "4.0.0"  ##This is optional
    }
  }
}

##Giving details of the provider. E.g. aws, gcp, etc
provider "aws" {
  # Configuration options

  ##region is the basically the location where amazon cloud data centre is located. 
  ##By default : Data center closest to us geographically is being choosed
  region = "us-east-1" 
  #version = "4.0.0"  ##This is optional 
  access_key = "AKIAV6JZEVYDL5AU746S"
  secret_key = "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"
}

/*
#For providing resources of the provider we are using
resource "<provider>_<resource_type>" "name" {
  #name: this is name given by us to this resource so that we can use anywhere else when we reference this resource
  #config options here w.r.t. that resource type in form of key-value pairs
  key1 = value1
  key2 = value2
}
*/

resource "aws_instance" "my-first-server" {
  ami           = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"

}

/*
Terraform commands:
terraform init : Initializes the backend and download all necessarry plugins for our providers(E.g. AWS)
terraform plan : dry runs our terraform code & will show us what all changes will it make. Recommended before applying changes.
    #E.g. adding/modifying/deleting resources. 
    + : adding resources(green)
    - : removing resources(red)
    ~ : modifying resources(orange)
terraform apply : will tell us what all changes to be made and then will ask us if we need to make/apply the changes
terraform apply --auto-approve : Will directly apply changes without asking us

Note: If we run 'terraform apply' again on same code, then it will be not create those instances/resources again(that have been 
created in first run) coz terraform is written in declarative manner i.e. it doesn't run our code step by step rather terraform
code basically tells us that what we want our infrastructure to look like in the en, so in our code we give exact blueprint of
what our infrastructure should look like. Terraform does this by maintaining the state of our code via using statefile
(terraform.tfstate) For e.g. below code just tells that we should have only 1 ec2 instance, so not matter
how many times we run/apply this code, ec2 instance will only be created in the first run.

    resource "aws_instance" "my-first-server" {
    ami           = "ami-0e472ba40eb589f49"
    instance_type = "t2.micro"

    }

*/


/*
resource "aws_instance" "my-second-server" {
  ami           = "ami-0b0af3577fe5e3532"
  instance_type = "t2.micro"

  tags = {
    Name = "ubuntu"
  }

}
*/


/*
terraform destroy : to destroy all the resources we have created. In case we want to delete only specific resources then we
need to pass some parameters.

Another way if destroying resources is just removing the code. For e.g. if we'll remove/comment the above (resource "aws_instance" "my-second-server") 
code from this file, then that machine will automatically be destroyed. This is possible coz terraform is written in declarative
manner.
*/


#########Referencing#####

resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "testing"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id   ##Mapping to id of above created vpc
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "test"
  }
}

/*
We know that subnets are created inside vpc. So we always first need to define vpc resource and then subnet resource but this is not
true coz if we'll define subnet first and then vpc, terraform is intelligent to understand which resource should be created first 
i.e. it will see that our subnet is referencing to vpc, so its first need to create vpc and then subnet.

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id   ##Mapping to id of above created vpc
  ...
}

resource "aws_vpc" "my_vpc" {
 ...
}
*/


/*
#####terraform files#####
####terraform/providers/.. folder and its sub files:
contains all the necessary plugins for our providers(E.g. AWS)
and are created when we initialize the terraform(terraform init). If we delete these manually we'll not be able
to apply our changes(terraform apply), rather we again need to initialize terrform so that these files should be created.

####terraform.tfstate:
This is a terraform state file.
whenever we create a resource within AWS(or any cloud  provider), we need a way for terraform to keep track of 
everything that's created, right? Because  that way, if we go to modify a parameter, like add an extra tag, or maybe 
change the instance type to from like a T to micro to a another size,it needs to be able to check that what is 
the current status of that resource i.e. what are its configurations and compare it to  what's in the code.
And the way terraform does this is, it just creates a simple text(json) terraform.tf state file.

If we ever go into this file and start deleting things, we will break terraform. So terraform will have a mismatched 
state from what's actually being deployed into AWS. So never mess around with the TF state file. It's a very important
file. And we it's absolutely crucial to the overall functionality of terraform.
*/

