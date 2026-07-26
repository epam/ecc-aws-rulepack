def _assert_no_rotation_enabled(base_test, r):
    base_test.assertNotIn('RotationEnabled', r)


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:secretsmanager:us-east-1:644160558196:secret:218_secret_red-x3O3e8',
                'arn:aws:secretsmanager:us-east-1:644160558196:secret:218_secret_red_b-k8L9m2',
            ],
        )
        for r in resources:
            _assert_no_rotation_enabled(base_test, r)


class PolicyTest_SpecificSecret(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:secretsmanager:us-east-1:644160558196:secret:218_secret_red-x3O3e8',
        )
        _assert_no_rotation_enabled(base_test, resources[0])


class PolicyTest_NoFoundSecrets(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
