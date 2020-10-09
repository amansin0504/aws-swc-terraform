output "swc-aws-iamrole" {
  value       = aws_iam_role.Obsrvbl_role_tf.arn
  description = "Role for Stealthwatch Cloud"
}

output "swc-aws-s3bucket" {
  value       = aws_s3_bucket.Obsrvblebucket.bucket
  description = "S3 Bucket name storing the VPC flow logs"
}
