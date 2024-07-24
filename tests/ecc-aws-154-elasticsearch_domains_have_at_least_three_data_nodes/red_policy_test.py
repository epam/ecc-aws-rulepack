class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        InstanceCount = resources[0]['ElasticsearchClusterConfig']['InstanceCount']
        AvailabilityZoneCount = resources[0]['ElasticsearchClusterConfig']['ZoneAwarenessConfig']['AvailabilityZoneCount']
        base_test.assertGreaterEqual(InstanceCount, 3)
        base_test.assertEqual(AvailabilityZoneCount,3)
        base_test.assertTrue(bool(InstanceCount % AvailabilityZoneCount))