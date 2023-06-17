class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['FileSystemType'], 'WINDOWS')
        base_test.assertEqual(resources[0]['WindowsConfiguration']['DeploymentType'], 'SINGLE_AZ_2')