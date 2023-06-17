class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        acl_id = resources[0]['WebACLId']
        waf_client = local_session.client("waf").get_web_acl(WebACLId=acl_id)
        base_test.assertFalse(waf_client["WebACL"]["Rules"])
        
