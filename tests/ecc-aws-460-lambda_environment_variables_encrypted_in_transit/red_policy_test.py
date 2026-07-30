class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        for resource in resources:
            base_test.assertIn('Variables', resource['Environment'])
            base_test.assertNotRegex(
                resource['Environment']['Variables']['foo'], '^AQICAH.*'
            )

        kms_resources = [r for r in resources if r.get('KMSKeyArn')]
        base_test.assertEqual(len(kms_resources), 1)
        base_test.assertEqual(
            kms_resources[0]['FunctionName'], '460_lambda_red_kms'
        )
