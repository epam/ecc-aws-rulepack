def _assert_job_bookmarks_disabled(base_test, r):
    base_test.assertEqual(
        r['EncryptionConfiguration']['JobBookmarksEncryption']['JobBookmarksEncryptionMode'],
        'DISABLED',
    )


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['Name'] for r in resources],
            [
                '401_security_configuration_green',
                '254_security_configuration_red_b',
            ],
        )
        for r in resources:
            _assert_job_bookmarks_disabled(base_test, r)


class PolicyTest_SpecificSecurityConfiguration(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Name'], '401_security_configuration_green')
        _assert_job_bookmarks_disabled(base_test, resources[0])


class PolicyTest_NoFoundSecurityConfigurations(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
