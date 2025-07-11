# Google Module for Vertex AI resources

This is a collection of submodules for vertex AI related resources.

- [Vertex AI workbench](./modules/workbench/)
- [Model Armor template](./modules/model-armor-template/)

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3+

### Enable API's
In order to operate with the Service Account you must activate the following API on the project where the Service Account was created:

- compute.googleapis.com
- iap.googleapis.com
- aiplatform.googleapis.com
- notebooks.googleapis.com
- cloudkms.googleapis.com

### Service Account

A service account with the following roles must be used to provision the resources of this module:

- Notebooks Admin: `roles/notebooks.admin`
- Cloud KMS CryptoKey Encrypter/Decrypter : `roles/cloudkms.cryptoKeyEncrypterDecrypter`
- Cloud KMS Admin: `roles/cloudkms.admin`
- Compute Network Admin: `roles/compute.networkAdmin`
- Project IAM Admin: `roles/resourcemanager.projectIamAdmin`
- Service Account Admin: `roles/iam.serviceAccountAdmin`
- Service Account User: `roles/iam.serviceAccountUser`
