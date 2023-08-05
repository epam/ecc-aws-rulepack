class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotIn("elb-284-green", resources[0]['LoadBalancerNames'])
        base_test.assertFalse(resources[0]['TargetGroupARNs'])