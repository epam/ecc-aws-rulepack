def _assert_no_rules(base_test, waf_client, web_acl_id):
    acl = waf_client.get_web_acl(WebACLId=web_acl_id)['WebACL']
    base_test.assertFalse(acl['Rules'])


class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['WebACLArn'] for r in resources],
            [
                'arn:aws:waf::111111111111:webacl/811fa220-5703-44f8-b3ba-77e69853a0af',
                'arn:aws:waf::111111111111:webacl/922fa220-5703-44f8-b3ba-77e69853a0b0',
            ],
        )
        waf_client = local_session.client('waf')
        for r in resources:
            _assert_no_rules(base_test, waf_client, r['WebACLId'])


class PolicyTest_SpecificWebACL(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['WebACLArn'],
            'arn:aws:waf::111111111111:webacl/811fa220-5703-44f8-b3ba-77e69853a0af',
        )
        waf_client = local_session.client('waf')
        _assert_no_rules(base_test, waf_client, resources[0]['WebACLId'])


class PolicyTest_NoFoundWebACLs(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
