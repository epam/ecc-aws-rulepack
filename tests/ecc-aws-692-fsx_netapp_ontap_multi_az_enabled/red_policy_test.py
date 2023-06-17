class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['FileSystemType'], 'ONTAP')
        base_test.assertEqual(resources[0]['OntapConfiguration']['DeploymentType'], 'SINGLE_AZ_1')
