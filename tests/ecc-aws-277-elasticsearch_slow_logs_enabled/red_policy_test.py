def _assert_slow_logs(base_test, r):
    base_test.assertTrue(r['LogPublishingOptions']['SEARCH_SLOW_LOGS']['Enabled'])
    base_test.assertNotIn('INDEX_SLOW_LOGS', r['LogPublishingOptions'])


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:es:us-east-1:111111111111:domain/domain-277-red',
                'arn:aws:es:us-east-1:111111111111:domain/domain-277-red-b',
            ],
        )
        for r in resources:
            _assert_slow_logs(base_test, r)


class PolicyTest_SpecificDomain(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:es:us-east-1:111111111111:domain/domain-277-red',
        )
        _assert_slow_logs(base_test, resources[0])


class PolicyTest_NoFoundDomains(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
