class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertGreater(len(resources[0]['BlockDeviceMappings']), 0, 'EBS volumes not mounted')
        base_test.assertIn(False, [volume['Ebs']['DeleteOnTermination'] for volume in resources[0]['BlockDeviceMappings']], 'No misconfigured EBS volumes')
