class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotIn("CustomOriginConfig",resources[0]["Origins"]["Items"][0])
        s3_bucket_name = resources[0]["Origins"]["Items"][0]["DomainName"].split(".")
        s3_bucket_name=s3_bucket_name[0]
        s3_client = local_session.client("s3").list_buckets()['Buckets']
        for bucket in s3_client:
          base_test.assertNotEqual(s3_bucket_name,bucket['Name'])