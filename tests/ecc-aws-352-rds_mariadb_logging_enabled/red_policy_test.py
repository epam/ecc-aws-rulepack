class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Engine'], "mariadb")
        base_test.assertNotIn('error',resources[0]['EnabledCloudwatchLogsExports'])
        parameter_group_name=resources[0]["DBParameterGroups"][0]["DBParameterGroupName"]
        
        describe_parameters = local_session.client("rds").describe_db_parameters(DBParameterGroupName=parameter_group_name)
        parameters=describe_parameters["Parameters"]
        marker=describe_parameters["Marker"] if "Marker" in describe_parameters else None

        while marker is not None:
          for parameter in parameters:
            if parameter["ParameterName"]=="log_output":
              base_test.assertIn('ParameterValue', parameter)
              base_test.assertNotEqual(parameter['ParameterValue'], 'FILE')

          describe_parameters = local_session.client("rds").describe_db_parameters(DBParameterGroupName=parameter_group_name, Marker=marker)
          parameters=describe_parameters["Parameters"]
          marker=describe_parameters["Marker"] if "Marker" in describe_parameters else None
        
        option_group_name=resources[0]["OptionGroupMemberships"][0]["OptionGroupName"]
        option_settings = local_session.client("rds").describe_option_groups(OptionGroupName=option_group_name)["OptionGroupsList"][0].get("Options")[0].get("OptionSettings")
        for setting in option_settings:
          if setting.get("Name") == "SERVER_AUDIT_EVENTS":
            base_test.assertNotIn('QUERY_DDL',setting.get("Value").split(","))

 
