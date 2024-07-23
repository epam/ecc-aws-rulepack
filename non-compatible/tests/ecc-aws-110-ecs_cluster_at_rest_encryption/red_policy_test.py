class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        encryption = local_session.client('ec2').describe_volumes()['Volumes'][0]
        volumeInstance = encryption['Attachments'][0]['InstanceId']
        container = local_session.client('ecs').describe_container_instances(containerInstances = volumeInstance.split())
        containerInstance = container['containerInstances'][0]['ec2InstanceId']
        base_test.assertNotEqual(resources[0]['registeredContainerInstancesCount'], 0)
        base_test.assertEqual(containerInstance, volumeInstance)
        base_test.assertFalse(encryption['Encrypted'])