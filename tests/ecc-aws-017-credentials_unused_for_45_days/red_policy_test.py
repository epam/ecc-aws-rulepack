class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['UserName'] for r in resources],
            ['USER', 'USER2'],
        )
        for r in resources:
            base_test.assertEqual(
                r['c7n:credential-report']['password_last_used'],
                '2020-02-25T09:26:50+00:00',
            )
            base_test.assertEqual(
                r['c7n:credential-report']['password_last_changed'],
                '2020-02-25T09:59:26+00:00',
            )
            base_test.assertEqual(
                r['c7n:credential-report']['access_keys'][0]['last_used_date'],
                '2020-02-26T07:27:09+00:00',
            )
            base_test.assertEqual(
                r['c7n:credential-report']['access_keys'][0]['last_rotated'],
                '2020-02-26T07:27:09+00:00',
            )


class PolicyTest_SpecificUser(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Arn'], 'arn:aws:iam::121212121212:user/USER')
        base_test.assertEqual(resources[0]['c7n:credential-report']['password_last_used'], '2020-02-25T09:26:50+00:00')
        base_test.assertEqual(resources[0]['c7n:credential-report']['password_last_changed'], '2020-02-25T09:59:26+00:00')
        base_test.assertEqual(resources[0]['c7n:credential-report']['access_keys'][0]['last_used_date'], '2020-02-26T07:27:09+00:00')
        base_test.assertEqual(resources[0]['c7n:credential-report']['access_keys'][0]['last_rotated'], '2020-02-26T07:27:09+00:00')


class PolicyTest_NoFoundUsers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)

