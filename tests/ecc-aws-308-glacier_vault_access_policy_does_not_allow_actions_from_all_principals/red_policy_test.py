def _assert_principal_star_policy(base_test, policy_str):
    base_test.assertRegex(policy_str, '.*\"Principal\":\"[*]\".*')


class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['VaultARN'] for r in resources],
            [
                'arn:aws:glacier:us-east-1:111111111111:vaults/308_glacier_vault_red',
                'arn:aws:glacier:us-east-1:111111111111:vaults/308_glacier_vault_red_b',
            ],
        )
        glacier_client = local_session.client('glacier')
        for r in resources:
            policy = glacier_client.get_vault_access_policy(
                accountId='-',
                vaultName=r['VaultName'],
            )['policy']['Policy']
            _assert_principal_star_policy(base_test, policy)


class PolicyTest_SpecificVault(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['VaultARN'],
            'arn:aws:glacier:us-east-1:111111111111:vaults/308_glacier_vault_red',
        )
        glacier_client = local_session.client('glacier')
        policy = glacier_client.get_vault_access_policy(
            accountId='-',
            vaultName=resources[0]['VaultName'],
        )['policy']['Policy']
        _assert_principal_star_policy(base_test, policy)


class PolicyTest_NoFoundVaults(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
