class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertIn("kmsKeyId", resources[0]["configuration"]["managedStorageConfiguration"])
        base_test.assertIsNotNone("kmsKeyId", resources[0]["configuration"]["managedStorageConfiguration"])
        base_test.assertNotIn("fargateEphemeralStorageKmsKeyId", resources[0]["configuration"]["managedStorageConfiguration"])