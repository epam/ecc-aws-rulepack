class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        aws_lambda = resources[0]
        iam_client = local_session.client('iam')
        policies = iam_client.list_role_policies(RoleName=aws_lambda['Role'].split('/')[1])
        policy_role_name = policies['PolicyNames'][0]
        check = iam_client.get_role_policy(RoleName=aws_lambda['Role'].split('/')[1],
                                       PolicyName=policy_role_name)
        result = check['PolicyDocument']['Statement'][0]['Resource']
        base_test.assertEqual(result, '*')