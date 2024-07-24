class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        s3 = local_session.client("s3").get_bucket_logging(Bucket=resources[0]["S3BucketName"])
        base_test.assertNotIn("LoggingEnabled", s3)
