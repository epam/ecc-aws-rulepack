class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['Arn'] for r in resources],
            [
                'arn:aws:airflow:us-east-1:111111111111:environment/mwaa_444_red',
                'arn:aws:airflow:us-east-1:111111111111:environment/mwaa_444_red2',
            ],
        )
        for r in resources:
            base_test.assertFalse(r['LoggingConfiguration']['DagProcessingLogs']['Enabled'])
            base_test.assertEqual(r['LoggingConfiguration']['DagProcessingLogs']['LogLevel'], 'INFO')


class PolicyTest_SpecificEnvironment(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['Arn'],
            'arn:aws:airflow:us-east-1:111111111111:environment/mwaa_444_red',
        )
        base_test.assertFalse(resources[0]['LoggingConfiguration']['DagProcessingLogs']['Enabled'])
        base_test.assertEqual(resources[0]['LoggingConfiguration']['DagProcessingLogs']['LogLevel'], 'INFO')


class PolicyTest_NoFoundEnvironments(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
