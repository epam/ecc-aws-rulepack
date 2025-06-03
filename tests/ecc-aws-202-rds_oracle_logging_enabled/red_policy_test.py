class PolicyTest(object):

     def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertRegex(resources[0]['Engine'], "oracle")
        base_test.assertNotIn('trace',resources[0]['EnabledCloudwatchLogsExports'])