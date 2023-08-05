class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        bucket_id = resources[0]['Name']
        s3_client = local_session.client("s3").get_bucket_notification_configuration(Bucket=bucket_id)['ResponseMetadata']
        base_test.assertEqual(s3_client,{})
        