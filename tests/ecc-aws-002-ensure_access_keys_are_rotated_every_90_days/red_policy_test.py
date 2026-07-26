class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['UserName'] for r in resources],
            ['USER', 'USER2'],
        )
        for r in resources:
            base_test.assertEqual(
                r['c7n:credential-report']['access_keys'][0]['last_rotated'],
                '2021-01-08T07:30:10+00:00',
            )
            base_test.assertTrue(r['c7n:credential-report']['access_keys'][0]['active'])


class PolicyTest_SpecificUser(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Arn'], 'arn:aws:iam::121212121212:user/USER')
        base_test.assertEqual(resources[0]['c7n:credential-report']['access_keys'][0]['last_rotated'], '2021-01-08T07:30:10+00:00')
        base_test.assertTrue(resources[0]['c7n:credential-report']['access_keys'][0]['active'])


class PolicyTest_NoFoundUsers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
