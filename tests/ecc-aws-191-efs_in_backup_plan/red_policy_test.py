class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotEqual(resources[0]['Tags'][0]['Key'], "aws:elasticfilesystem:default-backup")
        base_test.assertNotEqual(resources[0]['Tags'][1]['Key'], "aws:elasticfilesystem:default-backup")
        base_test.assertLess(len(resources[0]['Tags']), 3)