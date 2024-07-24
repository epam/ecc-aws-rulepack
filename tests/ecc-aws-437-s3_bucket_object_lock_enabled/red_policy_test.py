from botocore.exceptions import ClientError
class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        client = local_session.client("s3")
        try:
          lock_config = client.get_object_lock_configuration(Bucket=resources[0]['Name'])
        except ClientError as e:
          base_test.assertEqual(e.response['Error']['Code'],"ObjectLockConfigurationNotFoundError")