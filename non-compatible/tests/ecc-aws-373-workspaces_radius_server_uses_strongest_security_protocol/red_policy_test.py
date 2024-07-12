class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        ds = local_session.client("ds").describe_directories(DirectoryIds=["d-9067b0b800"])
        base_test.assertNotEqual(ds['DirectoryDescriptions'][0]['RadiusSettings']['AuthenticationProtocol'],'MS-CHAPv2')

        
