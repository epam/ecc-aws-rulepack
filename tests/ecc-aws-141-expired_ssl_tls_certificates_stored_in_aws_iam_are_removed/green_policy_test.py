class PolicyTest(object):

    def mock_time(self):
        return 2022, 5, 12

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
