class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        waf_client = local_session.client("waf").list_activated_rules_in_rule_group(RuleGroupId=resources[0]['RuleGroupId'])
        base_test.assertFalse(waf_client["ActivatedRules"])