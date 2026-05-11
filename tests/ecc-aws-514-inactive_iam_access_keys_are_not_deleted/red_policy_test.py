class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['UserName'] for r in resources],
            ['514_user_red', '514_user_red2'],
        )
        for r in resources:
            base_test.assertFalse(r['c7n:credential-report']['access_keys'][0]['active'])


class PolicyTest_SpecificUser(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Arn'], 'arn:aws:iam::111111111111:user/514_user_red')
        base_test.assertFalse(resources[0]['c7n:credential-report']['access_keys'][0]['active'])


class PolicyTest_NoFoundUsers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
