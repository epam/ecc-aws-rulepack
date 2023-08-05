class PolicyTest(object):

     def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotEqual(resources[0]['LustreConfiguration']['AutomaticBackupRetentionDays'], 7)