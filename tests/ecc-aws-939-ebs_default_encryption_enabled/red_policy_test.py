class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertFalse(local_session.client("ec2").get_ebs_encryption_by_default()['EbsEncryptionByDefault'])