class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        KeyArn = resources[0]['EncryptionKeyArn']
        
        kms_client = local_session.client("kms")
        aliases = kms_client.list_aliases()
        for alias_arn in aliases['Aliases'][0]['AliasArn']:
            if alias_arn == KeyArn:
                base_test.assertEqual(alias_arn, "alias/aws/backup")
