class PolicyTest(object):

    def mock_time(self):
        return 2021, 7, 2

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['DNSName'], 'alb-https-010-red-646554336.us-east-1.elb.amazonaws.com')
