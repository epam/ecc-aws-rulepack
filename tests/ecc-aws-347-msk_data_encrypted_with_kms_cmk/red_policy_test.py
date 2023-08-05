class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        key_raw = resources[0]['EncryptionInfo']['EncryptionAtRest']['DataVolumeKMSKeyId']
        key_id = key_raw.split('/')
        kms = local_session.client("kms").describe_key(KeyId=key_id[1])
        base_test.assertEqual(kms['KeyMetadata']['KeyManager'], 'AWS')