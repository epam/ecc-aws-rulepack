class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        app_name = resources[0]['ApplicationName']
        conf_settings = local_session.client("elasticbeanstalk").describe_configuration_settings(ApplicationName=app_name)
        options = conf_settings['ConfigurationSettings'][0]['OptionSettings']

        for option in options:
          if option["OptionName"]=="Notification Topic ARN":
            sns = local_session.client("sns").get_topic_attributes(TopicArn=option["Value"])
            base_test.assertEqual(sns["Attributes"]["SubscriptionsConfirmed"], "0")