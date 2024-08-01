class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        
        base_test.assertEqual(len(resources[0]['LoadBalancerNames']), 1)
        base_test.assertNotEqual(resources[0]['HealthCheckType'], "ELB")