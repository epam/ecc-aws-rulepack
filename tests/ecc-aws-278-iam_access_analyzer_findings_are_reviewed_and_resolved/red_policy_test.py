class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        analyzerArn = local_session.client("accessanalyzer").list_analyzers()['analyzers'][0]["arn"]
        findings = local_session.client("accessanalyzer").list_findings(analyzerArn=analyzerArn)
        for finding in findings['findings']:
            if 'status' in finding:
                base_test.assertEqual(finding['status'], 'ACTIVE')
