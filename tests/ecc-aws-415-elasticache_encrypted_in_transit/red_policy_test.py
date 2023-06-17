class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertFalse(resources[0]['AtRestEncryptionEnabled'])