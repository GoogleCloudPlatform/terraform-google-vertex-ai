# Upgrade to v10.0

The v10.0 release contains backwards-incompatible changes. This document outlines the breaking changes introduced in v10.0 of the `model-armor-floorsetting` module and provides instructions on how to upgrade your existing Terraform configurations.

## Breaking Changes

### 1. Replacement of `enable_malicious_uri_filter_settings` with `malicious_uri_filter_settings`
The boolean variable `enable_malicious_uri_filter_settings` (`default = false`) has been replaced by `malicious_uri_filter_settings` (`type = string`, `default = null`).

- Allowed values: `"ENABLED"`, `"DISABLED"`, or `null` (omits `malicious_uri_filter_settings`).
- Unlike the previous boolean variable, this supports explicitly sending `filter_enforcement = "DISABLED"` to turn off an existing Malicious URI filter via `PATCH`.

### 2. Change in `sdp_settings.basic_config_filter_enforcement` Type
The `basic_config_filter_enforcement` attribute inside `sdp_settings` has changed from `bool` (`optional(bool, false)`) to `string` (`optional(string)`).

- Allowed values: `"ENABLED"`, `"DISABLED"`, or `null`.
- Setting `basic_config_filter_enforcement` alongside `advanced_config` is rejected by input validation.
- Setting `sdp_settings = {}` no longer emits an empty `sdp_settings` block.

### 3. Strict Single-Parent Validation (`project_id`, `folder_id`, `org_id`)
Previously, providing more than one of `project_id`, `folder_id`, and `org_id` silently selected one using `Project > Folder > Organization` precedence.

- Now, **exactly one** of `project_id`, `folder_id`, or `org_id` must be provided. Providing zero or multiple parent IDs fails the resource precondition.
- Variable validations also reject empty strings and resource prefixes (`projects/`, `folders/`, `organizations/`). `folder_id` and `org_id` must be numeric strings.

## Upgrade Instructions

### Step 1: Replace `enable_malicious_uri_filter_settings`
Update any module calls passing `enable_malicious_uri_filter_settings`:

- `enable_malicious_uri_filter_settings = true` -> `malicious_uri_filter_settings = "ENABLED"`
- `enable_malicious_uri_filter_settings = false` -> remove the argument (default `null`, omits the block) or set `malicious_uri_filter_settings = "DISABLED"` to explicitly disable it.

### Step 2: Update `sdp_settings.basic_config_filter_enforcement`
Update `sdp_settings` boolean values to strings:

- `basic_config_filter_enforcement = true` -> `basic_config_filter_enforcement = "ENABLED"`
- `basic_config_filter_enforcement = false` -> remove `basic_config_filter_enforcement` (or set to `null`), or set `basic_config_filter_enforcement = "DISABLED"` to explicitly disable SDP basic config.

### Step 3: Ensure Exactly One Parent ID Is Set
Remove any redundant parent IDs so only one of `project_id`, `folder_id`, or `org_id` is non-null, and strip any `projects/`, `folders/`, or `organizations/` prefix.

## Comparison Example

### Before (v9.x)
```hcl
module "model_armor_floorsetting" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/model-armor-floorsetting"
  version = "~> 9.0"

  project_id = "my-project-123"
  folder_id  = "456789012345"

  enable_malicious_uri_filter_settings = true

  sdp_settings = {
    basic_config_filter_enforcement = true
  }
}
```

### After (v10.0)
```hcl
module "model_armor_floorsetting" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/model-armor-floorsetting"
  version = "~> 10.0"

  project_id = "my-project-123"

  malicious_uri_filter_settings = "ENABLED"

  sdp_settings = {
    basic_config_filter_enforcement = "ENABLED"
  }
}
```
