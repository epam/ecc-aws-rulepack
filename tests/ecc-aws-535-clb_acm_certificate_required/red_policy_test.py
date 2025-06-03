class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['ListenerDescriptions'][0]['Listener']['Protocol'], 'SSL') 
        base_test.assertRegex(resources[0]['ListenerDescriptions'][0]['Listener']['SSLCertificateId'], '^arn:aws:iam::.*$' ) 
