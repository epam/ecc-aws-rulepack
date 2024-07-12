class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)

    def mock_time(self):
        return 2021, 6, 15
