class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertIn('"Effect":"Allow"', resources[0]['Policy'])
        base_test.assertIn('"Principal":"*"', resources[0]['Policy'])
        base_test.assertIn('"Action":"*"', resources[0]['Policy'])