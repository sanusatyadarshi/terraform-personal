variable "AWS_ACCESS_KEY" {default = "xxxxxxxxxx"}
variable "AWS_SECRET_KEY" {default = "xxxxxxxxxxxxxxxx"}
variable "AWS_REGION" {
  default = "us-east-1"
}
variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-04763b3055de4860b"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-0d729a60"
  }
}
