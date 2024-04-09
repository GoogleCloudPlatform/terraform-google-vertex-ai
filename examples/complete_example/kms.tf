module "kms" {
  source          = "terraform-google-modules/kms/google"
  version         = "~> 2.2"
  project_id      = var.project_id
  location        = "us-central1"
  keyring         = "vertex-keyring-test-${random_id.suffix.hex}"
  keys            = ["test"]
  prevent_destroy = false
}

data "google_project" "project" {
  project_id = var.project_id
}

# https://cloud.google.com/vertex-ai/docs/workbench/instances/cmek#grant_permissions
# https://cloud.google.com/vertex-ai/docs/general/cmek#configure-cmek

resource "google_project_service_identity" "sa_notebooks" {
  provider = google-beta

  project = var.project_id
  service = "notebooks.googleapis.com"
}

resource "google_project_iam_member" "sa_notebooks" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:${google_project_service_identity.sa_notebooks.email}"
}


resource "google_project_service_identity" "sa_aiplatform" {
  provider = google-beta

  project = var.project_id
  service = "aiplatform.googleapis.com"
}

resource "google_project_iam_member" "sa_aiplatform" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:${google_project_service_identity.sa_aiplatform.email}"
}

resource "google_project_iam_member" "sa_compute_engine" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"
}
