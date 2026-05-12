def _assert_rotation_not_ok(base_test, r):
    base_test.assertTrue(r['RotationEnabled'])
    base_test.assertNotIn('LastRotatedDate', r)


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:secretsmanager:us-east-1:644160558196:secret:219_secret_red-vpxrBy',
                'arn:aws:secretsmanager:us-east-1:644160558196:secret:219_secret_red_b-wqzrCy',
            ],
        )
        for r in resources:
            _assert_rotation_not_ok(base_test, r)


class PolicyTest_SpecificSecret(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:secretsmanager:us-east-1:644160558196:secret:219_secret_red-vpxrBy',
        )
        _assert_rotation_not_ok(base_test, resources[0])


class PolicyTest_NoFoundSecrets(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
