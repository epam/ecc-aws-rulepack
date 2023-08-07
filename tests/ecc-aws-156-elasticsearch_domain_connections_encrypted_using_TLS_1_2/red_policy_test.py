class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        endpoint = (resources[0]['DomainEndpointOptions'])
        base_test.assertFalse(endpoint['EnforceHTTPS'])
        base_test.assertIsNot(endpoint['TLSSecurityPolicy'], "Policy-Min-TLS-1-2-2019-07")