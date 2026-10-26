import datetime


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        access_key_creation_time = str(resources[0]['c7n:credential-report']['access_keys'][0]['last_rotated'])
        user_creation_time = str(resources[0]['c7n:credential-report']['user_creation_time'])
        user_time_pattern = "%Y-%m-%dT%H:%M:%S"
        access_key_pattern = "%Y-%m-%dT%H:%M:%S"
        timezone_pattern_position = -6
        filtered_access_key_creation_time = datetime.datetime.strptime(
            access_key_creation_time[:timezone_pattern_position], access_key_pattern)
        filtered_user_creation_time = datetime.datetime.strptime(
            user_creation_time[:timezone_pattern_position], user_time_pattern)
        result_time = filtered_access_key_creation_time - filtered_user_creation_time

        base_test.assertEqual(1, result_time.seconds)
        base_test.assertTrue(resources[0]['c7n:credential-report']['password_enabled'])
        base_test.assertTrue(resources[0]['c7n:credential-report']['access_keys'][0]['active'])
        base_test.assertIsNone(resources[0]['c7n:credential-report']['access_keys'][0]['last_used_date'])
