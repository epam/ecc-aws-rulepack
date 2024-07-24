class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Entries'][1]['PortRange']['From'], 22)
        base_test.assertEqual(resources[0]['Entries'][1]['CidrBlock'], "0.0.0.0/0")
        base_test.assertFalse(resources[0]['Entries'][1]['Egress'])
        base_test.assertEqual(resources[0]['Entries'][1]['RuleAction'], "allow")
        base_test.assertEqual(resources[0]['Entries'][2]['PortRange']['From'], 3389)
        base_test.assertEqual(resources[0]['Entries'][2]['CidrBlock'], "0.0.0.0/0")
        base_test.assertFalse(resources[0]['Entries'][2]['Egress'])
        base_test.assertEqual(resources[0]['Entries'][2]['RuleAction'], "allow")
        
        
