class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['Arn'] for r in resources],
            [
                'arn:aws:iam::111111111111:group/499-group-red',
                'arn:aws:iam::111111111111:group/499-group-red-b',
            ],
        )
        iam_client = local_session.client('iam')
        for r in resources:
            users = iam_client.get_group(GroupName=r['GroupName'])['Users']
            base_test.assertFalse(users)


class PolicyTest_SpecificGroup(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Arn'], 'arn:aws:iam::111111111111:group/499-group-red')
        iam_client = local_session.client('iam')
        users = iam_client.get_group(GroupName=resources[0]['GroupName'])['Users']
        base_test.assertFalse(users)


class PolicyTest_NoFoundGroups(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
