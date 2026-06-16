class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['Arn'] for r in resources],
            [
                'arn:aws:airflow:us-east-1:111111111111:environment/mwaa_446_red',
                'arn:aws:airflow:us-east-1:111111111111:environment/mwaa_446_red2',
            ],
        )
        for r in resources:
            base_test.assertFalse(r['LoggingConfiguration']['TaskLogs']['Enabled'])
            base_test.assertEqual(r['LoggingConfiguration']['TaskLogs']['LogLevel'], 'INFO')


class PolicyTest_SpecificEnvironment(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['Arn'],
            'arn:aws:airflow:us-east-1:111111111111:environment/mwaa_446_red',
        )
        base_test.assertFalse(resources[0]['LoggingConfiguration']['TaskLogs']['Enabled'])
        base_test.assertEqual(resources[0]['LoggingConfiguration']['TaskLogs']['LogLevel'], 'INFO')


class PolicyTest_NoFoundEnvironments(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
