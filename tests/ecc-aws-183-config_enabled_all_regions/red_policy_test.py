class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertFalse(resources[0]['c7n:config_recorders'][0]['recordingGroup']['allSupported'])
        base_test.assertFalse(resources[0]['c7n:config_recorders'][0]['recordingGroup']['includeGlobalResourceTypes'])
        config_client = local_session.client("config")
        config_status = config_client.describe_configuration_recorder_status()
        base_test.assertFalse(config_status['ConfigurationRecordersStatus'][0]['recording'])
