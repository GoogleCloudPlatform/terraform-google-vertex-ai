// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package feature_online_store_example

import (
	"context"
	"fmt"
	"strings"
	"testing"

	aiplatform "cloud.google.com/go/aiplatform/apiv1"
	"cloud.google.com/go/aiplatform/apiv1/aiplatformpb"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
	"google.golang.org/api/option"
)

func TestFeatureOnlineStore(t *testing.T) {
	fosTest := tft.NewTFBlueprintTest(t)

	fosTest.DefineVerify(func(assert *assert.Assertions) {
		fosTest.DefaultVerify(assert)

		projectId := fosTest.GetStringOutput("project_id")
		region := "us-central1"
		fosShortName := fosTest.GetStringOutput("feature_online_store_name_output")
		tfFosId := fosTest.GetStringOutput("feature_online_store_id")

		assert.True(strings.HasPrefix(fosShortName, "example_featurestore_name_"), "featurestore_name should start with 'example_featurestore_name_'")

		expectedTfFosId := fmt.Sprintf("projects/%s/locations/%s/featureOnlineStores/%s", projectId, region, fosShortName)
		assert.Equal(expectedTfFosId, tfFosId, "Mismatched Terraform output feature_online_store_id format")

		// --- API Call and Response Validation using Go Client Library ---
		ctx := context.Background()
		endpoint := fmt.Sprintf("%s-aiplatform.googleapis.com:443", region)
		client, err := aiplatform.NewFeatureOnlineStoreAdminClient(ctx, option.WithEndpoint(endpoint))
		if err != nil {
			assert.FailNowf("Failed to create FeatureOnlineStoreAdminClient", "Error: %v", err)
		}
		defer client.Close()

		req := &aiplatformpb.GetFeatureOnlineStoreRequest{
			Name: tfFosId,
		}
		resp, err := client.GetFeatureOnlineStore(ctx, req)
		if err != nil {
			assert.FailNowf("Failed to get FeatureOnlineStore", "Error: %v", err)
		}

		// --- Assertions on API Response ---
		apiFosId := resp.Name
		expectedSuffix := fmt.Sprintf("locations/%s/featureOnlineStores/%s", region, fosShortName)
		assert.Contains(apiFosId, expectedSuffix, "Full resource name (ID) from API should contain the location and short name")

		assert.Equal("true", resp.Labels["goog-terraform-provisioned"], "Expected goog-terraform-provisioned label to be true in labels")

		assert.Nil(resp.GetBigtable(), "Storage type shouldn't be bigtable")
		assert.NotNil(resp.GetOptimized(), "Optimized storage block should exist")

		// --- Private Service Connect Assertions ---
		pscConfig := resp.GetDedicatedServingEndpoint().GetPrivateServiceConnectConfig()
		assert.True(pscConfig.GetEnablePrivateServiceConnect(), "Mismatched enablePrivateServiceConnect")
		assert.Empty(pscConfig.GetProjectAllowlist(), "PSC projectAllowlist should be empty")

		// --- PSC Service Attachment ---
		serviceAttachmentOutput := fosTest.GetStringOutput("psc_service_attachment")
		apiServiceAttachment := resp.GetDedicatedServingEndpoint().GetServiceAttachment()
		assert.Equal(serviceAttachmentOutput, apiServiceAttachment, "Mismatched PSC service attachment URI")
	})

	fosTest.Test()
}
