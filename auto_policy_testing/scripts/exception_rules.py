aws = {
    "green": [
        "ecc-aws-519-vpc_vpn_2_tunnels_up",
        "ecc-aws-194-elb_deletion_protection_enabled",
        "ecc-aws-112-s3_bucket_versioning_mfa_delete_enabled",
        "ecc-aws-025-instance_without_termination_protection",
        # Reserved instances cannot be provisioned by auto_policy_testing terraform
        "ecc-aws-577-reserved_ec2_instance_payment_failed",
        "ecc-aws-578-reserved_ec2_instance_payment_pending",
        "ecc-aws-579-reserved_ec2_instance_recent_purchases",
        "ecc-aws-580-reserved_instance_lease_expiration_in_30_days",
        "ecc-aws-581-reserved_instance_lease_expiration_in_7_days",
        # Reserved Elasticsearch instances cannot be provisioned by auto_policy_testing terraform
        "ecc-aws-587-elasticsearch_reserved_instance_payment_failed",
        "ecc-aws-588-elasticsearch_reserved_instance_payment_pending",
        "ecc-aws-589-elasticsearch_reserved_instance_recent_purchases",
        # Reserved Redshift nodes cannot be provisioned by auto_policy_testing terraform
        "ecc-aws-595-reserved_redshift_node_payment_failed",
        "ecc-aws-596-reserved_redshift_node_payment_pending",
        "ecc-aws-597-reserved_redshift_node_recent_purchases",
        # WAF Classic (v1) WebACL creation blocked since 2025-05-01
        "ecc-aws-524-waf_regional_webacl_not_empty",
        "ecc-aws-527-waf_global_webacl_not_empty",
    ],
    "red": [
        "ecc-aws-022-ebs_volumes_too_old_snapshots",
        "ecc-aws-552-dynamodb_tables_unused",
        "ecc-aws-519-vpc_vpn_2_tunnels_up",
        "ecc-aws-071-codebuild_project_source_repo_url_check",
        "ecc-aws-092-ami_public_access",
        # Reserved instances cannot be provisioned by auto_policy_testing terraform
        "ecc-aws-577-reserved_ec2_instance_payment_failed",
        "ecc-aws-578-reserved_ec2_instance_payment_pending",
        "ecc-aws-579-reserved_ec2_instance_recent_purchases",
        "ecc-aws-580-reserved_instance_lease_expiration_in_30_days",
        "ecc-aws-581-reserved_instance_lease_expiration_in_7_days",
        # Reserved Elasticsearch instances cannot be provisioned by auto_policy_testing terraform
        "ecc-aws-587-elasticsearch_reserved_instance_payment_failed",
        "ecc-aws-588-elasticsearch_reserved_instance_payment_pending",
        "ecc-aws-589-elasticsearch_reserved_instance_recent_purchases",
        # Reserved Redshift nodes cannot be provisioned by auto_policy_testing terraform
        "ecc-aws-595-reserved_redshift_node_payment_failed",
        "ecc-aws-596-reserved_redshift_node_payment_pending",
        "ecc-aws-597-reserved_redshift_node_recent_purchases",
        # Previous-generation Redshift nodes (dc1/ds2) can no longer be created
        "ecc-aws-598-redshift_instance_generation",
        # New Redshift clusters are always encrypted (AWS default since Jan 2025)
        "ecc-aws-126-redshift_instances_are_encrypted",
        # Require multi-week age that cannot be created by terraform
        "ecc-aws-185-ec2_stopped_instance",
        "ecc-aws-610-idle_ec2_instance",
        # EKS versions matching these policy thresholds can no longer be created in AWS
        "ecc-aws-497-eks_cluster_oldest_supported_version",
        # Glue catalog encryption is account-singleton; red uses SSE-KMS/aws/glue for 253+365
        "ecc-aws-252-glue_data_catalog_encrypted_at_rest",
        # AppSync always enables cache encryption for new caches (AWS change Jun 2025)
        "ecc-aws-441-appsync_cache_encrypted_at_rest",
        "ecc-aws-442-appsync_cache_encrypted_in_transit",
        # autoMinorVersionUpgrade must be set to true for ActiveMQ brokers version 5.18 and above and for RabbitMQ brokers version 3.13 and above.
        "ecc-aws-339-mq_broker_auto_minor_version_upgrade_enabled",
        # WAF Classic (v1) WebACL creation blocked since 2025-05-01
        "ecc-aws-524-waf_regional_webacl_not_empty",
        "ecc-aws-527-waf_global_webacl_not_empty",

    ]
}
