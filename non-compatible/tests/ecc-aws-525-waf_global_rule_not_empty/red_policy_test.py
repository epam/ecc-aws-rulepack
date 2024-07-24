class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        waf_client = local_session.client("waf").get_rule(RuleId=resources[0]['RuleId'])['Rule']
        base_test.assertFalse(waf_client["Predicates"])