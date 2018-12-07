# Define the backend of terraform state 
# this is important as the terraform will rely on the state file 
# that been generated the last time the terraform apply was commited
terraform {
  backend "s3" {
    bucket = "ruchi-state-storage"
    key    = "terraform/docker-cluster"
    region = "ap-southeast-2"
  }
}
