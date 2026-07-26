def _assert_dedicated_masters(base_test, r):
    config = r['ElasticsearchClusterConfig']
    base_test.assertTrue(config['DedicatedMasterEnabled'])
    base_test.assertLessEqual(config['DedicatedMasterCount'], 2)


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:es:us-east-1:111111111111:domain/domain-155-red',
                'arn:aws:es:us-east-1:111111111111:domain/domain-155-red-b',
            ],
        )
        for r in resources:
            _assert_dedicated_masters(base_test, r)


class PolicyTest_SpecificDomain(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:es:us-east-1:111111111111:domain/domain-155-red',
        )
        _assert_dedicated_masters(base_test, resources[0])


class PolicyTest_NoFoundDomains(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
