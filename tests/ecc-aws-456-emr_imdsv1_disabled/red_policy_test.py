class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        emr_client = local_session.client("emr")
        config_name = resources[0]['SecurityConfiguration']
        configuration = emr_client.describe_security_configuration(Name=config_name)
        base_test.assertRegexpMatches(configuration['SecurityConfiguration'], r'\"MinimumInstanceMetadataServiceVersion\": 1')
