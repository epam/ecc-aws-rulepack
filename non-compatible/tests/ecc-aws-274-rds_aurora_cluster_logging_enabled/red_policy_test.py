class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Engine'], "aurora")
        
        parameter_group_name=resources[0]["DBClusterParameterGroup"]
        describe_parameters = local_session.client("rds").describe_db_cluster_parameters(DBClusterParameterGroupName=parameter_group_name)  
        parameters=describe_parameters["Parameters"]
        marker=describe_parameters["Marker"] if "Marker" in describe_parameters else None

        while marker is not None:
        
          for parameter in parameters:
            if parameter["ParameterName"]=="slow_query_log":
              base_test.assertIn('ParameterValue', parameter)
              base_test.assertEqual(parameter['ParameterValue'], '0')
            elif parameter["ParameterName"]=="general_log":
              base_test.assertIn('ParameterValue', parameter)
              base_test.assertEqual(parameter['ParameterValue'], '1')
            elif parameter["ParameterName"]=="log_output":
              base_test.assertIn('ParameterValue', parameter)
              base_test.assertEqual(parameter['ParameterValue'], "FILE")

          describe_parameters = local_session.client("rds").describe_db_cluster_parameters(DBClusterParameterGroupName=parameter_group_name, Marker=marker)
          parameters=describe_parameters["Parameters"]
          marker=describe_parameters["Marker"] if "Marker" in describe_parameters else None
