class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        print(resources[0]['Runtime'])
        base_test.assertEqual(resources[0]['Runtime'], "python2.7")
