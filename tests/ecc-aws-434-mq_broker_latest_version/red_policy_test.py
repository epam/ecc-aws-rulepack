class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['EngineType'], 'RabbitMQ')
        base_test.assertNotRegex(resources[0]['EngineVersion'], '3.13.*')