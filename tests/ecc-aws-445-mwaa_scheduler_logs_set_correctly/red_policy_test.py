class PolicyTest(object):

     def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertTrue(resources[0]['LoggingConfiguration']['SchedulerLogs']['Enabled'])
        base_test.assertNotEqual(resources[0]['LoggingConfiguration']['SchedulerLogs']['LogLevel'], 'INFO')