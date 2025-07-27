import re

class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        aws_lambda = resources[0]
        iam_client = local_session.client('iam')
        attached_policies = iam_client.list_attached_role_policies(RoleName=aws_lambda['Role'].split('/')[1])
        policy_names = [p['PolicyName'] for p in attached_policies['AttachedPolicies']]
        regex = re.compile(r'.*FullAccess.*')
        matches = [name for name in policy_names if regex.match(name)]
        base_test.assertTrue(len(matches) > 0, f"No attached policy matches regex: {regex.pattern}")