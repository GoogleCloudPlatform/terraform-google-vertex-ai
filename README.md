Copyright 2023 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

# Google Module for Vertex AI

This is a collection of submodules that make it easier to non-destructively manage multiple IAM roles for resources on Google Cloud Platform:
[Vertex AI workbench](./modules/workbench/)

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3+
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v4.79+

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
