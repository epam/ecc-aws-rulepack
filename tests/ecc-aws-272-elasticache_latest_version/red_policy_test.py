class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertIn(resources[0]['Engine'], ("redis", "memcached"))
        base_test.assertIn(resources[0]['EngineVersion'], ("7.0.7", "1.5.16"))