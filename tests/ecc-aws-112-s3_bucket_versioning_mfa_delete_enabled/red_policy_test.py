class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Versioning']['Status'], 'Enabled')
        base_test.assertNotIn('MFADelete', resources[0]['Versioning'])
