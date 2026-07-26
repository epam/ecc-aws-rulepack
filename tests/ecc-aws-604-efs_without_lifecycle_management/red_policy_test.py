class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['FileSystemArn'] for r in resources],
            [
                'arn:aws:elasticfilesystem:us-east-1:644160558196:file-system/fs-0383ff4824ec50307',
                'arn:aws:elasticfilesystem:us-east-1:644160558196:file-system/fs-22222222222222222',
            ],
        )
        client = local_session.client('efs')
        for r in resources:
            cfg = client.describe_lifecycle_configuration(FileSystemId=r["FileSystemId"])
            base_test.assertEqual(len(cfg["LifecyclePolicies"]), 0)


class PolicyTest_SpecificFileSystem(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['FileSystemArn'],
            'arn:aws:elasticfilesystem:us-east-1:644160558196:file-system/fs-0383ff4824ec50307',
        )
        client = local_session.client('efs')
        cfg = client.describe_lifecycle_configuration(FileSystemId=resources[0]["FileSystemId"])
        base_test.assertEqual(len(cfg["LifecyclePolicies"]), 0)


class PolicyTest_NoFoundFileSystems(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
