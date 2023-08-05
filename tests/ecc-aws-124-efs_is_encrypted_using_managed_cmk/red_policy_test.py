class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertTrue(resources[0] ["Encrypted"])
        kms_key_client = local_session.client("kms")
        key = kms_key_client.describe_key(KeyId=resources[0]["KmsKeyId"])
        base_test.assertNotEqual(key["KeyMetadata"]["KeyManager"], "CUSTOMER")
