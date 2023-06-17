class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertIn(resources[0]['Status']['State'], ['RUNNING', 'WAITING'])
        base_test.assertNotIn('Realm', resources[0]['KerberosAttributes'])