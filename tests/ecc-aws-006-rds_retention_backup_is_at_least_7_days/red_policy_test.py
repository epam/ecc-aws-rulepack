class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertLess(resources[0]['BackupRetentionPeriod'], 7)
        base_test.assertNotEqual(resources[0]['BackupRetentionPeriod'], 0)
        base_test.assertNotIn("StatusInfos", resources[0])
        