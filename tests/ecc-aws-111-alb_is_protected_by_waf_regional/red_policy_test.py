class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        client_waf_classic = local_session.client('waf-regional')
        WebACLs = client_waf_classic.list_web_acls().get('WebACLs', ())
        base_test.assertFalse(WebACLs)
        
        client_waf_classic = local_session.client('wafv2')
        WebACLs = client_waf_classic.list_web_acls(Scope = "REGIONAL").get('WebACLs', ())
        base_test.assertFalse(WebACLs)
