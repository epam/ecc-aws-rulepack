class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertListEqual(resources[0]['logging']['clusterLogging'][0]['types'], ['api', 'audit',  'controllerManager', 'scheduler'])
        base_test.assertTrue(resources[0]['logging']['clusterLogging'][0]['enabled'])

