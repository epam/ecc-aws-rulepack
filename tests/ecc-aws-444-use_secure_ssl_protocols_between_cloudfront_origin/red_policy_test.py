class PolicyTest(object):

     def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Origins']['Items'][0]['CustomOriginConfig']['OriginSslProtocols']['Items'][0], 'TLSv1.1')