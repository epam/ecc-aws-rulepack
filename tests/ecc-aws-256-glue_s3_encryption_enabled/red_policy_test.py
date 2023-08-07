class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['EncryptionConfiguration']["S3Encryption"][0]['S3EncryptionMode'], "DISABLED")