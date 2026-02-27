# Upgrade to v4.0

This document outlines the breaking changes introduced in the latest release of the `model-armor-floorsetting` module and provides instructions on how to upgrade your existing Terraform configurations.

## Breaking Changes

The `model-armor-floorsetting` module has undergone a significant architectural change to simplify input handling and enhance validation.

### 1. Removal of `location` Variable
The `location` variable has been removed as an input. The module now hardcodes the location to `"global"`, which is the only supported value for Model Armor Floor Settings.

### 2. Replacement of `parent_id` with Specific ID Variables
The generic `parent_id` variable has been removed. It is replaced by three context-specific variables: `project_id`, `folder_id`, and `org_id`. This change allows for better validation via Terraform preconditions.

### 3. Change in `integrated_services` Type
The `integrated_services` variable type has been tightened from `list(any)` to `list(string)`.

## Upgrade Instructions

To upgrade to the new version of the module, please follow these steps:

### Step 1: Remove Deprecated Inputs
Locate your module call for `model-armor-floorsetting` and remove the following attributes:
- `location`
- `parent_id`

### Step 2: Add Context-Specific ID Variable
Depending on your `parent_type`, you must now provide the corresponding ID variable.

| If `parent_type` is... | Add this variable: |
| :--- | :--- |
| `"project"` | `project_id = "your-project-id"` |
| `"folder"` | `folder_id = "your-folder-id"` |
| `"organization"` | `org_id = "your-org-id"` |

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
  parent_type  = "project"
  project_id   = "my-project-123"
  # location is now global by default
  # ... other variables
}
```

## Validation
The module now includes a lifecycle precondition to ensure that the ID variable corresponding to your selected `parent_type` is not null. If the required variable is missing, Terraform will return the following error:
`"The ID variable corresponding to the selected parent_type must not be null."`

