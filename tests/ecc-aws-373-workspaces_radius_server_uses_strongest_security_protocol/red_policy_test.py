class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        ds = local_session.client("ds").describe_directories(DirectoryIds=[resources[0]['DirectoryId']])
        base_test.assertNotEqual(ds['DirectoryDescriptions'][0]['RadiusSettings']['AuthenticationProtocol'],'MS-CHAPv2')

