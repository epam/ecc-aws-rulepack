class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        group_name = resources[0]['GroupName']
        iam_client = local_session.client("iam").get_group(GroupName=group_name)
        base_test.assertFalse(iam_client["Users"])