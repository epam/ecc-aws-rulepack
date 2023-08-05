class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        client = local_session.client('waf-regional')
        WebACLs = client.list_web_acls().get('WebACLs', ())
        base_test.assertFalse(WebACLs)
