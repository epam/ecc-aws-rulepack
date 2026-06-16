class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['UserName'] for r in resources],
            ['user_with_policy', 'user_with_policy2'],
        )
        for r in resources:
            base_test.assertTrue(r['c7n:Policies'][0]['PolicyName'])


class PolicyTest_SpecificUser(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Arn'], 'arn:aws:iam::121212121212:user/user_with_policy')
        base_test.assertTrue(resources[0]['c7n:Policies'][0]['PolicyName'])


class PolicyTest_NoFoundUsers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)

