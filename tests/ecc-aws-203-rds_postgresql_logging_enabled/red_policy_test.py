class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Engine'], "postgres")
        base_test.assertNotIn('upgrade',resources[0]['EnabledCloudwatchLogsExports'])
        base_test.assertIn('postgresql',resources[0]['EnabledCloudwatchLogsExports'])
        parameter_group_name=resources[0]["DBParameterGroups"][0]["DBParameterGroupName"]
        
        describe_parameters = local_session.client("rds").describe_db_parameters(DBParameterGroupName=parameter_group_name)
        parameters=describe_parameters["Parameters"]
        marker=describe_parameters["Marker"] if "Marker" in describe_parameters else None

        while marker is not None:
          for parameter in parameters:
            if parameter["ParameterName"]=="log_statement":
              base_test.assertIn('ParameterValue', parameter)
              base_test.assertEqual(parameter['ParameterValue'], 'all')
            elif parameter["ParameterName"]=="log_min_duration_statement":
              base_test.assertNotIn('ParameterValue', parameter)
          describe_parameters = local_session.client("rds").describe_db_parameters(DBParameterGroupName=parameter_group_name, Marker=marker)
          parameters=describe_parameters["Parameters"]
          marker=describe_parameters["Marker"] if "Marker" in describe_parameters else None