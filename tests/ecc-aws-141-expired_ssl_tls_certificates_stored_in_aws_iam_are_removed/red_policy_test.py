class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(str(resources[0]['Expiration']), '2022-05-11 13:08:36+00:00')