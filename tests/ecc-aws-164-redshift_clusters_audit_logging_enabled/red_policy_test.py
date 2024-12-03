class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        client = local_session.client("redshift")
        redshift_id = resources[0]['ClusterIdentifier']
        result = client.describe_logging_status(
            ClusterIdentifier=redshift_id)
        base_test.assertTrue(result["LoggingEnabled"])
        base_test.assertIn("userlog", result["LogExports"])
        base_test.assertNotIn("connectionlog", result["LogExports"])
        
