class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotRegex(resources[0]['ViewerCertificate']['MinimumProtocolVersion'],"TLSv1\.2_*") 