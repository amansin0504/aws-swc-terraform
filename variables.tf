variable "S3BucketName" {
  type        = string
  description = "Name of the S3 buckets to store the VPC Flow Logs"
}

variable "ObsrvbleIDName" {
  type        = string
  description = "Stealthwatch Cloud Observable ID"
}

variable "VPCIDs" {
  description = "Enter a list of VPC IDs to be monitored"
  type        = list(string)
}
