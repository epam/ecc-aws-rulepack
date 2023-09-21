# Changelog

## [v3.10] - 2023-09-20
### :sparkles: New Policies
- [`9f014d6`](https://github.com/epam/ecc-aws-rulepack/commit/9f014d6d7b9d632892456a9fb8c2f43734bc8e4c) - added policy ecc-aws-547-rds_instance_generation
- [`11ef8ce`](https://g1111ithub.com/epam/ecc-aws-rulepack/commit/11ef8ce13557dccc76af9693326baa893eafa047) - added policy ecc-aws-552-dynamodb_tables_unused
- [`f0dc7d1`](https://github.com/epam/ecc-aws-rulepack/commit/f0dc7d1321cd1c34586d2552897b0e09e07e4cf9) - added policy ecc-aws-553-unused_clb
- [`cbe41ca`](https://github.com/epam/ecc-aws-rulepack/commit/cbe41ca2a68cf43525709844f48b2181a9ac589b) - added policy ecc-aws-560-unused_sns_topic

### :wrench: Updates
- [`1fb3342`](https://github.com/epam/ecc-aws-rulepack/commit/1fb334233bd44fe3defe0833a7a8962da1533338) - added index(comment) to all rules
- [`0b6311c`](https://github.com/epam/ecc-aws-rulepack/commit/0b6311cfbd74f232d3471af356ec65964b7f9fb4) - updated policy ecc-aws-548-ebs_volumes_are_of_type_gp3_instead_of_gp2
- [`ea93aa3`](https://github.com/epam/ecc-aws-rulepack/commit/ea93aa3645cf7a02fe5ff102af164e5a54f65021) - updated comment field for all policies
- [`cd33519`](https://github.com/epam/ecc-aws-rulepack/commit/cd33519fb70c65c1bf042e790410ca494979be93) - updated policy 043

### :adhesive_bandage: Policy Fixes
- [`595a1b0`](https://github.com/epam/ecc-aws-rulepack/commit/595a1b008035836ab7bf40de5ffc069eb71ca238) - fixed policy 298


## [v2.0] - 2023-08-21
### :sparkles: New Policies
- [`b54d258`](https://github.com/epam/ecc-aws-rulepack/commit/b54d2585b6c5ed5c248e984b1e56d4600ef36804) - added non compatible policies (see the list in the commit message)
- [`5e4393b`](https://github.com/epam/ecc-aws-rulepack/commit/5e4393b696405a1df10948e21d769ca5258ecf4d) - added a number of terraform files for policies (see the list in the commit message)
- [`3e9aed2`](https://github.com/epam/ecc-aws-rulepack/commit/3e9aed26e5cd52269a4dfff1178811d0bc5e27e9) - added policy ecc-aws-807-unused_efs_filesystem
- [`4d48faf`](https://github.com/epam/ecc-aws-rulepack/commit/4d48fafe6e7f7078871e23518357d7e4c01ef987) - added policy ecc-aws-1005-ebs_volumes_too_old_snapshots
- [`737f6e8`](https://github.com/epam/ecc-aws-rulepack/commit/737f6e8e04a086940c8b3ce9d62fdeca3e565a08) - added policy ecc-aws-526-waf_global_rulegroup_not_empty *(commit by [@anna-shcherbak](https://github.com/anna-shcherbak))*
- [`075a903`](https://github.com/epam/ecc-aws-rulepack/commit/075a90393bbe3e3cbf14078d43571e906dadb03a) - added policy ecc-aws-529-ebs_attached_volume_delete_on_termination_enabled *(commit by [@anna-shcherbak](https://github.com/anna-shcherbak))*
- [`e7208b3`](https://github.com/epam/ecc-aws-rulepack/commit/e7208b304eaebdb900829062755c00f179a98d8c) - added policy ecc-aws-543-cloudfront_realtime_logging_enabled *(commit by [@anna-shcherbak](https://github.com/anna-shcherbak))*
- [`ad35d4c`](https://github.com/epam/ecc-aws-rulepack/commit/ad35d4c92254ef057917581d3ccf50dd27f64336) - added policy ecc-aws-546-kinesis_streams_retention_period_set_correctly *(commit by [@anna-shcherbak](https://github.com/anna-shcherbak))*
- [`5810523`](https://github.com/epam/ecc-aws-rulepack/commit/58105237039362f3cddc5af8e5acd0c40cf59ec7) - added policy ecc-aws-548-ebs_volumes_are_of_type_gp3_instead_of_gp2

### :wrench: Updates
- [`84be271`](https://github.com/epam/ecc-aws-rulepack/commit/84be27105e5bc79d17de588e4081b417fad728e6) - re-index all policies *(commit by [@anna-shcherbak](https://github.com/anna-shcherbak))*

### :adhesive_bandage: Terraform Fixes
- [`5dd197c`](https://github.com/epam/ecc-aws-rulepack/commit/5dd197cc3b2ff431a17b1fdc84b60f983656004a) - fixed a number of terraform files for policies (see the list in the commit message)

### :adhesive_bandage: Test Fixes
- [`a9870e4`](https://github.com/epam/ecc-aws-rulepack/commit/a9870e4dc3a7852bc0bf1ceb620104880c47fdfb) - fixed tests for policy 490 *(commit by [@anna-shcherbak](https://github.com/anna-shcherbak))*
- [`e54a209`](https://github.com/epam/ecc-aws-rulepack/commit/e54a209e9c5cb5f84d3e9fd5fd928e24d75188e5) - fixed tests for policy 111 *(commit by [@anna-shcherbak](https://github.com/anna-shcherbak))*

### :memo: Documentation Changes
- [`55363ec`](https://github.com/epam/ecc-aws-rulepack/commit/55363ec708eb954556b934663f46a2c78e27ff86) - added README.md for non-compatible-policies


## [v1.0] - 2023-07-12
### :open_file_folder: Initial version


[v1.0]: https://github.com/epam/ecc-aws-rulepack/compare/Init...v1.0

[v2.0]: https://github.com/epam/ecc-aws-rulepack/compare/v1.0...v2.0
[v3.0]: https://github.com/epam/ecc-aws-rulepack/compare/v2.0...v3.0
