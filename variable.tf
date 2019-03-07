/*variable "gcp_region" {
  default = "us-east1"
}

variable "region_zone" {
  default = "us-east1-a"
}

variable "credentials_file_path" {
  description = "credentials file path"
  default = "~/.gcloud/credential_file.json"
}*/

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "region" {
  default = "us-west-1"
}

variable "availibility_zone" {
  default = "us-west-1a"
}
//variable "do_token" {
//  default = ""
//}

variable "ami" {
  default = "ami-0f95cde6ebe3f5ec3"  #"ami-8c73b1e1"

}

variable "instance_type" {
  default = "t2.medium"
}

