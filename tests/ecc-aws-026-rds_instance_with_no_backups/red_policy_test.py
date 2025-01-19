class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['BackupRetentionPeriod'], 0)
        base_test.assertNotIn("StatusInfos", resources[0])