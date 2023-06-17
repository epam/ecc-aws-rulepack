
class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        kms_client = local_session.client("kms")
        key_id = resources[0]['c7n:matched-kms-key'][0]
        key_manager = kms_client.describe_key(KeyId=key_id)['KeyMetadata']['KeyManager']
        base_test.assertEqual(key_manager, 'AWS')