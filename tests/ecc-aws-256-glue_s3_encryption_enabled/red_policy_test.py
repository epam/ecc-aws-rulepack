def _assert_s3_encryption_disabled(base_test, r):
    base_test.assertEqual(
        r['EncryptionConfiguration']['S3Encryption'][0]['S3EncryptionMode'],
        'DISABLED',
    )


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['Name'] for r in resources],
            [
                '256_security_configuration_red',
                '256_security_configuration_red_b',
            ],
        )
        for r in resources:
            _assert_s3_encryption_disabled(base_test, r)


class PolicyTest_SpecificSecurityConfiguration(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Name'], '256_security_configuration_red')
        _assert_s3_encryption_disabled(base_test, resources[0])


class PolicyTest_NoFoundSecurityConfigurations(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
