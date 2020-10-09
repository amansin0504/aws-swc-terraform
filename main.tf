provider "aws" {
  profile     = "default"
  region      = "us-east-1"
}

#############################
# S3 Bucket for VPC Flow logs
#############################
resource "aws_s3_bucket" "Obsrvblebucket" {
  bucket = var.S3BucketName
  acl    = "private"
  tags = {
    Name        = "BucketForVPCFlowLogs"
  }
}

###################################
# IAM Policy for Stealthwatch Cloud
###################################
data "template_file" "Obsrvbl_policy_doc" {
  template = file("Obsrvbl_policy_tf.json")

  vars = {
    S3Name = var.S3BucketName
  }
}

resource "aws_iam_role_policy" "Obsrvbl_policy_tf" {
  name = "Obsrvbl_policy_tf"
  role = aws_iam_role.Obsrvbl_role_tf.id
  policy = data.template_file.Obsrvbl_policy_doc.rendered
}

######################################
# S3 IAM Policy for Stealthwatch Cloud
######################################
data "template_file" "Obsrvbl_s3policy_doc" {
  template = file("Obsrvbl_s3policy_tf.json")

  vars = {
    S3Name = var.S3BucketName
  }
}

resource "aws_iam_role_policy" "Obsrvbl_s3policy_tf" {
  name = "Obsrvbl_s3policy_tf"
  role = aws_iam_role.Obsrvbl_role_tf.id
  policy = data.template_file.Obsrvbl_s3policy_doc.rendered
}

#####################################
# IAM Role for for Stealthwatch Cloud
#####################################
data "template_file" "Obsrvbl_role_doc" {
  template = file("Obsrvbl_role_tf.json")

  vars = {
    ObsrvbleID = var.ObsrvbleIDName
  }
}

resource "aws_iam_role" "Obsrvbl_role_tf" {
  name = "Obsrvbl_role_tf"
  assume_role_policy = data.template_file.Obsrvbl_role_doc.rendered
}

#################################
# VPC Flow logs for selected VPCs
#################################
resource "aws_flow_log" "VPCFlowLogDeliveryToS3" {
  count = length(var.VPCIDs)
  log_destination      = aws_s3_bucket.Obsrvblebucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  log_format           = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${vpc-id} $${subnet-id} $${instance-id} $${tcp-flags} $${type} $${pkt-srcaddr} $${pkt-dstaddr}"
  vpc_id               = var.VPCIDs[count.index]
}
