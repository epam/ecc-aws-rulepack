def _assert_tls(base_test, r):
    endpoint = r['DomainEndpointOptions']
    base_test.assertFalse(endpoint['EnforceHTTPS'])
    base_test.assertIsNot(
        endpoint['TLSSecurityPolicy'],
        'Policy-Min-TLS-1-2-PFS-2023-10',
    )


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:es:us-east-1:this:domain/domain-156-red',
                'arn:aws:es:us-east-1:this:domain/domain-156-red-b',
            ],
        )
        for r in resources:
            _assert_tls(base_test, r)


class PolicyTest_SpecificDomain(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:es:us-east-1:this:domain/domain-156-red',
        )
        _assert_tls(base_test, resources[0])


class PolicyTest_NoFoundDomains(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
