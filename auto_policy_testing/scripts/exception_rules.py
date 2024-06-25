aws = {
    "green": [
        "ecc-aws-015-ensure_mfa_is_enabled_for_the_root_account",
        "ecc-aws-112-s3_bucket_versioning_mfa_delete_enabled", #manual
        "ecc-aws-138-eliminate_use_root_user_for_administrative_and_daily_tasks",
        "ecc-aws-207-rds_aurora_logging_enabled",
        "ecc-aws-286-workspaces_unused_instances",
        "ecc-aws-331-workspaces_images_not_older_than_90_days", 
        "ecc-aws-519-vpc_vpn_2_tunnels_up",
        "ecc-aws-587-elasticsearch_reserved_instance_payment_failed",
        "ecc-aws-588-elasticsearch_reserved_instance_payment_pending",
        "ecc-aws-589-elasticsearch_reserved_instance_recent_purchases",
        "ecc-aws-591-reserved_rds_instance_payment_failed",
        "ecc-aws-592-reserved_rds_instance_payment_pending",
        "ecc-aws-593-reserved_rds_instance_recent_purchases",
        "ecc-aws-594-underutilized_rds_instance_storage",
        "ecc-aws-595-reserved_redshift_node_payment_failed",
        "ecc-aws-596-reserved_redshift_node_payment_pending",
        "ecc-aws-597-reserved_redshift_node_recent_purchases",
        "ecc-aws-614-idle_rds_instance"
    ],
    "red": [
        "ecc-aws-002-ensure_access_keys_are_rotated_every_90_days",
        "ecc-aws-016-ensure_hardware_mfa_is_enabled_for_root_account",  
        "ecc-aws-017-credentials_unused_for_45_days",      
        "ecc-aws-022-ebs_volumes_too_old_snapshots",
        "ecc-aws-046-ensure_no_root_account_access_key_exists",
        "ecc-aws-059-config_enabled_all_regions",
        "ecc-aws-115-expired_certificates_are_removed_from_acm",
        "ecc-aws-128-expired_route53_domain_names",
        "ecc-aws-138-eliminate_use_root_user_for_administrative_and_daily_tasks",
        "ecc-aws-141-expired_ssl_tls_certificates_stored_in_aws_iam_are_removed",
        "ecc-aws-145-organizations_changes_alarm_exists",
        "ecc-aws-207-rds_aurora_logging_enabled",
        "ecc-aws-253-glue_data_catalog_encrypted_with_kms_customer_master_keys",
        "ecc-aws-259-emr_clusters_in_vpc",
        "ecc-aws-288-workspaces_instances_are_healthy",
        "ecc-aws-331-workspaces_images_not_older_than_90_days", 
        "ecc-aws-344-route53_domain_expires_in_30_days",
        "ecc-aws-497-eks_cluster_oldest_supported_version",
        "ecc-aws-519-vpc_vpn_2_tunnels_up",
        "ecc-aws-536-lambda_function_settings_check",
        "ecc-aws-547-rds_instance_generation",
        "ecc-aws-552-dynamodb_tables_unused",
        "ecc-aws-571-stopped_rds_instances_removed",
        "ecc-aws-587-elasticsearch_reserved_instance_payment_failed",
        "ecc-aws-588-elasticsearch_reserved_instance_payment_pending",
        "ecc-aws-589-elasticsearch_reserved_instance_recent_purchases",
        "ecc-aws-591-reserved_rds_instance_payment_failed",
        "ecc-aws-592-reserved_rds_instance_payment_pending",
        "ecc-aws-593-reserved_rds_instance_recent_purchases",
        "ecc-aws-594-underutilized_rds_instance_storage",
        "ecc-aws-595-reserved_redshift_node_payment_failed",
        "ecc-aws-596-reserved_redshift_node_payment_pending",
        "ecc-aws-597-reserved_redshift_node_recent_purchases",
        "ecc-aws-598-redshift_instance_generation",
        "ecc-aws-614-idle_rds_instance"
    ],
    "not-parallel": [
        "glue",
        "account",
        "workspaces",
        "iam",
        "cloudtrail",
        "dms"
    ],
    "sleep_before_scan_3min": [
        "account",
        "ecr"
    ],
    "sleep_before_scan_5min": [
        "iam"
    ]
}

gcp = {}

azure = {}
