class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertTrue(resources[0]['c7n:credential-report']['password_enabled'])
        base_test.assertFalse(resources[0]['c7n:credential-report']['mfa_active'])
        base_test.assertEqual(resources[0]['Arn'], 'arn:aws:iam::121212121212:user/User')
        base_test.assertEqual(resources[1]['Arn'], 'arn:aws:iam::121212121212:user/User2')

class PolicyTest_SpecificUser(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertTrue(resources[0]['c7n:credential-report']['password_enabled'])
        base_test.assertFalse(resources[0]['c7n:credential-report']['mfa_active'])
        base_test.assertEqual(resources[0]['Arn'], 'arn:aws:iam::121212121212:user/User')

class PolicyTest_NoFoundUsers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
