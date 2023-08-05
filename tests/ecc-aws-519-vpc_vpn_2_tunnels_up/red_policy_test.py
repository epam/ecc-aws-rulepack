class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['VgwTelemetry'][0]['Status'], 'UP')
        base_test.assertEqual(resources[0]['VgwTelemetry'][1]['Status'], 'DOWN')
