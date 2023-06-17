class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotIn('encryptionKey', resources[0]['artifactStore'])