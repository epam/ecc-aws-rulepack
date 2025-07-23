class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        config = local_session.client("codedeploy").get_deployment_config(deploymentConfigName=resources[0]['deploymentConfigName'])
        base_test.assertLess(config['deploymentConfigInfo']['minimumHealthyHosts']['value'],66)
