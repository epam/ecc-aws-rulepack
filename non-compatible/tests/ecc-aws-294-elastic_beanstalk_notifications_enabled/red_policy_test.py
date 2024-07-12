class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        app_name = resources[0]['ApplicationName']
        conf_settings = local_session.client("elasticbeanstalk").describe_configuration_settings(ApplicationName=app_name)
        options = conf_settings['ConfigurationSettings'][0]['OptionSettings']

        for option in options:
          if option["OptionName"]=="Notification Topic ARN":
            base_test.assertNotIn('Value', option)