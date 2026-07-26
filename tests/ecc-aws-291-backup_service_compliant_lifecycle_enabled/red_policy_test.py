class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['BackupPlanArn'] for r in resources],
            [
                'arn:aws:backup:us-east-1:111111111111:backup-plan:ceed06ad-bfcc-406e-914f-3ad817eacd25',
                'arn:aws:backup:us-east-1:111111111111:backup-plan:11111111-1111-1111-1111-111111111111',
            ],
        )
        for r in resources:
            base_test.assertEqual(r['Rules'][0]['Lifecycle']['MoveToColdStorageAfterDays'], 365)
            base_test.assertNotIn('DeleteAfterDays', r['Rules'][0]['Lifecycle'])


class PolicyTest_SpecificBackupPlan(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['BackupPlanArn'],
            'arn:aws:backup:us-east-1:111111111111:backup-plan:ceed06ad-bfcc-406e-914f-3ad817eacd25',
        )
        base_test.assertEqual(resources[0]['Rules'][0]['Lifecycle']['MoveToColdStorageAfterDays'], 365)
        base_test.assertNotIn('DeleteAfterDays', resources[0]['Rules'][0]['Lifecycle'])


class PolicyTest_NoFoundBackupPlans(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
