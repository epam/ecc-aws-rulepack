class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertLess(resources[0]['c7n:password_policy']['MinimumPasswordLength'], 14)
