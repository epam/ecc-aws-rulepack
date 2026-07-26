def _assert_no_tags(base_test, r):
    base_test.assertEqual(r['Tags'], [])


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['VaultARN'] for r in resources],
            [
                'arn:aws:glacier:us-east-1:111111111111:vaults/413_glacier_vault_red',
                'arn:aws:glacier:us-east-1:111111111111:vaults/413_glacier_vault_red_b',
            ],
        )
        for r in resources:
            _assert_no_tags(base_test, r)


class PolicyTest_SpecificVault(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['VaultARN'],
            'arn:aws:glacier:us-east-1:111111111111:vaults/413_glacier_vault_red',
        )
        _assert_no_tags(base_test, resources[0])


class PolicyTest_NoFoundVaults(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
