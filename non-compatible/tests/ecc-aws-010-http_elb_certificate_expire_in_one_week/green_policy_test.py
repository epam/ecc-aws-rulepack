class PolicyTest(object):

    def mock_time(self):
        return 2021, 7, 2

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
