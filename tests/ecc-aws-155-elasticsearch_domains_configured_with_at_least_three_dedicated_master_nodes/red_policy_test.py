class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        config = (resources[0]['ElasticsearchClusterConfig'])
        base_test.assertTrue(config['DedicatedMasterEnabled'])
        base_test.assertLessEqual(config['DedicatedMasterCount'], 2)