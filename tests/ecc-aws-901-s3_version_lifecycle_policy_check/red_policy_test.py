from botocore.exceptions import ClientError

class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        bucket_id = resources[0]['Name']
        s3_client_versioning = local_session.client("s3").get_bucket_versioning(Bucket=bucket_id)
        base_test.assertEqual(s3_client_versioning['Status'],"Enabled")
        try:
          s3_client_lifecycle = local_session.client("s3").get_bucket_lifecycle_configuration(Bucket=bucket_id)
        except ClientError as e:
          base_test.assertEqual(e.response['Error']['Code'],"NoSuchLifecycleConfiguration")