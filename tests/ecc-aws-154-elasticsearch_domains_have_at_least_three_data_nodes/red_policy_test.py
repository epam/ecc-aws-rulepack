def _assert_cluster(base_test, r):
    instance_count = r['ElasticsearchClusterConfig']['InstanceCount']
    az_count = r['ElasticsearchClusterConfig']['ZoneAwarenessConfig']['AvailabilityZoneCount']
    base_test.assertGreaterEqual(instance_count, 3)
    base_test.assertEqual(az_count, 3)
    base_test.assertTrue(bool(instance_count % az_count))


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:es:us-east-1:111111111111:domain/domain-154-red2',
                'arn:aws:es:us-east-1:111111111111:domain/domain-154-red2-b',
            ],
        )
        for r in resources:
            _assert_cluster(base_test, r)


class PolicyTest_SpecificDomain(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:es:us-east-1:111111111111:domain/domain-154-red2',
        )
        _assert_cluster(base_test, resources[0])


class PolicyTest_NoFoundDomains(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
