class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        glacier_client = local_session.client("glacier")
        Name = resources[0]['VaultName']
        policy = glacier_client.get_vault_access_policy(accountId='-', vaultName=Name)['policy']['Policy']
        base_test.assertRegex(policy, ".*\\\"Principal\\\":\\\"[*]\\\".*")
        