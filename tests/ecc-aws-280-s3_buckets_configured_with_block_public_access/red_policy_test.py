class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        access_policy = resources[0]["c7n:PublicAccessBlock"]
        arr = []
        for i in access_policy:
            arr.append(access_policy[i])
        base_test.assertIn(False, arr)