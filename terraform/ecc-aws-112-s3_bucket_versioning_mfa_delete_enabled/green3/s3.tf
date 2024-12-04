#Only the bucket owner (root account) can enable MFA delete. 
#To disable MFA Delete on S3 bucket you need to be a ROOT user. Test it only in environment where you have access to root user, and will be able to disable MFA delete to clean resources.
/*
1. Deploy bucket with terraform
2. Log in to the root account console 
2. Create a new root access key 
3. Open CloudShell or local shell and use aws configure 
4. Enable MFA Delete with:
aws s3api put-bucket-versioning --bucket DOC-EXAMPLE-BUCKET1 --versioning-configuration Status=Enabled,MFADelete=Disabled --mfa "SERIAL 123456"
where SERIAL is full SerialNumber from 'aws iam list-virtual-mfa-devices'.
More details https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-versioning.html
*/

resource "aws_s3_bucket" "this" {
  bucket = "112-bucket-${random_integer.this.result}-green3"
  force_destroy = "true"
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

