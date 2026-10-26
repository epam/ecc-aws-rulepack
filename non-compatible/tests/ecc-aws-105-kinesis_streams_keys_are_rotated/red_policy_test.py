class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        kms_key_client = local_session.client("kms")
        key = kms_key_client.get_key_rotation_status(KeyId=resources[0]["KeyId"])
        base_test.assertFalse(key['KeyRotationEnabled'])
