class PolicyTest(object):

     def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotIn('RootVolumeEncryptionEnabled',resources[0])
        base_test.assertNotIn('UserVolumeEncryptionEnabled',resources[0])