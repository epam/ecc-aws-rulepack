class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertTrue(resources[0]['Entries'][0]['Egress'])
		
        base_test.assertLessEqual(resources[0]['Entries'][1]['PortRange']['From'], 22)
        base_test.assertEqual(resources[0]['Entries'][1]['CidrBlock'], "0.0.0.0/0")
        base_test.assertFalse(resources[0]['Entries'][1]['Egress'])
        base_test.assertEqual(resources[0]['Entries'][1]['RuleAction'], "allow")
        base_test.assertEqual(resources[0]['Entries'][1]['Protocol'], "6")
        base_test.assertGreaterEqual(resources[0]['Entries'][1]['PortRange']['To'], 22)
        rule_number1 = resources[0]['Entries'][1]['RuleNumber']
        
        base_test.assertEqual(resources[0]['Entries'][2]['CidrBlock'], "0.0.0.0/0")
        base_test.assertFalse(resources[0]['Entries'][2]['Egress'])
        base_test.assertEqual(resources[0]['Entries'][2]['RuleAction'], "deny")
        base_test.assertEqual(resources[0]['Entries'][2]['Protocol'], "-1")
        base_test.assertNotIn('PortRange', resources[0]['Entries'][2])
        rule_number2 = resources[0]['Entries'][2]['RuleNumber']
        
        base_test.assertLessEqual(rule_number1, rule_number2)