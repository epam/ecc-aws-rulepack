class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Origins']['Items'][0]['CustomOriginConfig']['OriginProtocolPolicy'], 'http-only')
        base_test.assertEqual(resources[0]['DefaultCacheBehavior']['ViewerProtocolPolicy'], 'allow-all')

        
