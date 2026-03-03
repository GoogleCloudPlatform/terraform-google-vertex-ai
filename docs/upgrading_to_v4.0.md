# Upgrade to v4.0

This document outlines the breaking changes introduced in the latest release of the `model-armor-floorsetting` module and provides instructions on how to upgrade your existing Terraform configurations.

## Breaking Changes

The `model-armor-floorsetting` module has undergone a significant architectural change to simplify input handling and enhance validation.

### 1. Removal of `location` Variable
The `location` variable has been removed as an input. The module now hardcodes the location to `"global"`, which is the only supported value for Model Armor Floor Settings.

### 2. Removal of `parent_id` and `parent_type`
The generic `parent_id` and `parent_type` variables have been removed. The module now automatically determines the parent resource type (Project, Folder, or Organization) based on which ID variable you provide. This change uses a precedence logic where the most specific scope provided takes priority.

### 3. Change in `integrated_services` Type
The `integrated_services` variable type has been tightened from `list(any)` to `list(string)`.

## Upgrade Instructions

To upgrade to the new version of the module, please follow these steps:

### Step 1: Remove Deprecated Inputs
Locate your module call for `model-armor-floorsetting` and remove the following attributes:
- `location`
- `parent_id`
- `parent_type`

### Step 2: Add Context-Specific ID Variable
You must now provide the ID variable corresponding to where you want to apply the floor settings. If multiple IDs are provided, the module follows this precedence: **Project > Folder > Organization**.

| Target Level | Add this variable: |
| :--- | :--- |
| **Project** (Highest Priority) | `project_id = "your-project-id"` |
| **Folder** | `folder_id = "your-folder-id"` |
| **Organization** | `org_id = "your-org-id"` |

### Step 3: Update `integrated_services` (If Applicable)
If you were passing non-string values to `integrated_services`, ensure they are now converted to a list of strings.

## Comparison Example

### Before
```hcl
module "model_armor_floorsetting" {
  source       = "..."
  parent_type  = "project"
  parent_id    = "my-project-123"
  location     = "global"
  # ... other variables
}
```

### After
```hcl
module "model_armor_floorsetting" {
  source       = "..."
  project_id   = "my-project-123"
  # parent_type and location are now handled automatically
  # ... other variables
}
```

## Validation
The module now includes a lifecycle precondition to ensure that at least one ID variable is provided. If all ID variables (`project_id`, `folder_id`, `org_id`) are null, Terraform will return the following error:
`"At least one of project_id, folder_id, or org_id must be provided to determine the parent resource."`

