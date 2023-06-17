class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Engine'], "aurora-mysql")
        base_test.assertFalse('BacktrackWindow' in resources[0])