class PolicyTest(object):

     def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertFalse(resources[0]['LoggingConfiguration']['TaskLogs']['Enabled'])
        base_test.assertEqual(resources[0]['LoggingConfiguration']['TaskLogs']['LogLevel'], 'INFO')