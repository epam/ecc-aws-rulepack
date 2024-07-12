class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        conf_settings = local_session.client("elasticbeanstalk").describe_configuration_settings(ApplicationName=resources[0]['ApplicationName'],
        EnvironmentName=resources[0]['EnvironmentName'])
        options = conf_settings['ConfigurationSettings'][0]['OptionSettings']

        for option in options:
            if option["OptionName"]=="DisableIMDSv1":
              base_test.assertEqual(option['Value'], 'false')
