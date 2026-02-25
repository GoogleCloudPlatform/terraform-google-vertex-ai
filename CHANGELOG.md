# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).
This changelog is generated automatically based on [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## [3.1.1](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v3.1.0...v3.1.1) (2026-02-23)


### Bug Fixes

* connection between model armour template and agent engine ([#79](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/79)) ([33815de](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/33815de7e65f2586926538c5f12bdf52206a4540))
* Remove default version for Python spec ([#85](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/85)) ([9076d29](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/9076d2962dd5a21012f8345337659cec4a20d0ba))

## [3.1.0](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v3.0.0...v3.1.0) (2026-02-18)


### Features

* Add source_code_spec in agent engine ([#82](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/82)) ([9bc8529](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/9bc85296a52527b0228c28785b7a661c1664511a))

## [3.0.0](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v2.4.0...v3.0.0) (2026-01-28)


### ⚠ BREAKING CHANGES

* **TPG>7.13:** added google_mcp_server_floor_setting in model armor floor setting sub-module ([#76](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/76))

### Features

* **TPG>7.13:** added google_mcp_server_floor_setting in model armor floor setting sub-module ([#76](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/76)) ([cffd0ea](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/cffd0ea20bb4dff2a5b28d2653e916a0e60875bd))


### Bug Fixes

* Changes to make model armour adc compliant ([#73](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/73)) ([28ed3e7](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/28ed3e770c730e457551489a20e4193c47b2a7e1))

## [2.4.0](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v2.3.1...v2.4.0) (2026-01-16)


### Features

* Add Vertex AI Reasoning Engine module ([#67](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/67)) ([a01ca9c](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/a01ca9c938578eaa0fd2b90a27b869e5d1a41971))

## [2.3.1](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v2.3.0...v2.3.1) (2025-10-24)


### Bug Fixes

* Metadata update for ADC compliance of feature online store module ([9ca8a5f](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/9ca8a5f7cabd20dd28ede88050bd4a7ae7820a8e))

## [2.3.0](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v2.2.0...v2.3.0) (2025-10-02)


### Features

* Add Vertex AI feature online store sub-module ([#58](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/58)) ([94b1c62](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/94b1c62168f8fb30b3e9ad5b7bacdd0cdb6675de))

## [2.2.0](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v2.1.1...v2.2.0) (2025-09-03)


### Features

* **deps:** Update Terraform Google Provider to v7 (major) ([#54](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/54)) ([e32ec99](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/e32ec99c9e075cba5e34bc0c50c6ad234941c2ca))

## [2.1.1](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v2.1.0...v2.1.1) (2025-08-12)


### Bug Fixes

* updated docs and example ([#51](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/51)) ([2cad6e6](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/2cad6e6666f743064a147e84f17723168f969ab2))

## [2.1.0](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v2.0.0...v2.1.0) (2025-08-07)


### Features

* added Model Armor floor setting sub-module ([#47](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/47)) ([a0684f1](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/a0684f1ca8d0831a1408c2b9927cbf7e5cdd4a9b))

## [2.0.0](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v1.0.0...v2.0.0) (2025-07-17)


### ⚠ BREAKING CHANGES

* added model-armor-template sub-module ([#41](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/41))

### Features

* added model-armor-template sub-module ([#41](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/41)) ([9df0942](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/9df09426dc41c75df72b9ac9068d167924f785ba))

## [1.0.0](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v0.2.0...v1.0.0) (2025-05-19)


### ⚠ BREAKING CHANGES

* **TPG >= 6.29:** added confidential_instance_type and enable_third_party_identity ([#38](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/38))

### Features

* **TPG >= 6.29:** added confidential_instance_type and enable_third_party_identity ([#38](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/38)) ([2b25c71](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/2b25c71862aacad6534521c6eef50a1a215e85e9))

## [0.2.0](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/compare/v0.1.0...v0.2.0) (2024-09-11)


### Features

* **deps:** Update Terraform Google Provider to v6 (major) ([#17](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/17)) ([859e5d8](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/859e5d82b9f465a02dddde22bfd1c74d91886ef7))


### Bug Fixes

* accelerator_configs var validation ([#18](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/18)) ([41ea7ec](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/41ea7ec813d9a06fbfedc16eaa2308db291b2652))

## 0.1.0 (2024-05-08)


### Bug Fixes

* initial release ([#9](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/issues/9)) ([bfa91ab](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/commit/bfa91ab72e1b0d96b3c01e1edd3664e135899c77))
