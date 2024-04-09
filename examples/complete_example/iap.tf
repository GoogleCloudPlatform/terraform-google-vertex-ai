# Custom Role at project level for IaP
resource "google_project_iam_custom_role" "os_login_custom_role" {
  project     = var.project_id
  role_id     = "osLoginCustomRole${random_id.suffix.hex}"
  title       = "Os Login prj level Custom Role"
  description = "Custom Project level role for os login"
  permissions = [
    "compute.projects.get",
  ]
}

# ##############################   IAP/OsLogin VM Level Permissions   ##########################################################################################
# ## OS Login Role at VM level. Will need compute.projects.get permission on project

resource "google_project_iam_member" "os_login_custom_role" {
  for_each = toset(var.instance_owners)
  project  = var.project_id
  role     = google_project_iam_custom_role.os_login_custom_role.name
  member   = "user:${each.value}"
}

# OsLogin Role at VM level
resource "google_compute_instance_iam_member" "vm_os_login" {
  for_each      = toset(var.instance_owners)
  project       = module.complete_vertex_ai_workbench.work_bench.project
  zone          = module.complete_vertex_ai_workbench.work_bench.location
  instance_name = module.complete_vertex_ai_workbench.work_bench.name
  role          = "roles/compute.osLogin"
  member        = "user:${each.value}"
}

# IAP Tunnel Role at VM level

resource "google_iap_tunnel_instance_iam_member" "vm_iap_tunnel_user" {
  for_each = toset(var.instance_owners)
  project  = module.complete_vertex_ai_workbench.work_bench.project
  zone     = module.complete_vertex_ai_workbench.work_bench.location
  instance = module.complete_vertex_ai_workbench.work_bench.name
  role     = "roles/iap.tunnelResourceAccessor"
  member   = "user:${each.value}"
}

# Service Account user role on instance service account
resource "google_service_account_iam_member" "instance_owner_sa_role" {
  for_each           = toset(var.instance_owners)
  service_account_id = google_service_account.workbench_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "user:${each.value}"
}
