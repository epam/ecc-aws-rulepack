class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['BackupVaultArn'] for r in resources],
            [
                'arn:aws:backup:us-east-1:111111111111:backup-vault:293_backup_vault_red',
                'arn:aws:backup:us-east-1:111111111111:backup-vault:293_backup_vault_red2',
            ],
        )

        kms_client = local_session.client("kms")
        aliases = kms_client.list_aliases()
        for r in resources:
            KeyArn = r['EncryptionKeyArn']
            for alias_arn in aliases['Aliases'][0]['AliasArn']:
                if alias_arn == KeyArn:
                    base_test.assertEqual(alias_arn, "alias/aws/backup")


class PolicyTest_SpecificBackupVault(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['BackupVaultArn'],
            'arn:aws:backup:us-east-1:111111111111:backup-vault:293_backup_vault_red',
        )


class PolicyTest_NoFoundBackupVaults(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
