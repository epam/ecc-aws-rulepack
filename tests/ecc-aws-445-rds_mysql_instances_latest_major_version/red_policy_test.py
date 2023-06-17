class PolicyTest(object):

     def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertIn(resources[0]['Engine'], 'mysql')
        base_test.assertIn(resources[0]['EngineVersion'], "5.7.33")
