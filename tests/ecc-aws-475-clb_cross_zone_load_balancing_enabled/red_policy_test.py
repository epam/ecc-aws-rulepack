class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        lbName = resources[0]['LoadBalancerName']
        connection = local_session.client("elb").describe_load_balancer_attributes(LoadBalancerName = lbName)
        base_test.assertFalse(connection['LoadBalancerAttributes']['CrossZoneLoadBalancing']['Enabled'])