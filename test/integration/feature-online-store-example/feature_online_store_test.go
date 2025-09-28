// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package feature_online_store_example

import (
    "fmt"
    "os/exec"
    "strings"
    "testing"

    "github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
    "github.com/stretchr/testify/assert"
    "github.com/tidwall/gjson"
)

func TestFeatureOnlineStore(t *testing.T) {
    fosTest := tft.NewTFBlueprintTest(t)

    fosTest.DefineVerify(func(assert *assert.Assertions) {
        fosTest.DefaultVerify(assert)

        projectId := fosTest.GetStringOutput("project_id")
        region := fosTest.GetStringOutput("region")
        fosShortName := fosTest.GetStringOutput("feature_online_store_name_output")
        tfFosId := fosTest.GetStringOutput("feature_online_store_id")

        assert.True(strings.HasPrefix(fosShortName, "example_featurestore_name_"), "featurestore_name should start with 'example_featurestore_name_'")

        expectedTfFosId := fmt.Sprintf("projects/%s/locations/%s/featureOnlineStores/%s", projectId, region, fosShortName)
        assert.Equal(expectedTfFosId, tfFosId, "Mismatched Terraform output feature_online_store_id format")

        // --- API Call and Response Validation ---
        tokenCmd := exec.Command("gcloud", "auth", "print-access-token")
        tokenOutput, err := tokenCmd.Output()
        if err != nil {
            assert.FailNowf("Failed to get auth token", "Error: %v", err)
        }
        token := strings.TrimSpace(string(tokenOutput))

        url := fmt.Sprintf("https://%s-aiplatform.googleapis.com/v1/projects/%s/locations/%s/featureOnlineStores/%s", region, projectId, region, fosShortName)

        curlCmd := exec.Command("curl", "-X", "GET", "-H", "Authorization: Bearer "+token, "-H", "Content-Type: application/json", url)
        output, err := curlCmd.Output()
        if err != nil {
            t.Logf("curl command output on error: %s", string(output))
            assert.FailNowf("Failed to query FeatureOnlineStore API", "Error: %v", err)
        }

        fosJson := gjson.ParseBytes(output)
        if !fosJson.Exists() {
            t.Logf("API Response: %s", string(output))
            assert.FailNow("Failed to parse JSON response from API")
        }

        // --- Assertions on API Response ---
        apiFosId := fosJson.Get("name").String()
        expectedSuffix := fmt.Sprintf("locations/%s/featureOnlineStores/%s", region, fosShortName)
        assert.Contains(apiFosId, expectedSuffix, "Full resource name (ID) from API should contain the location and short name")
        assert.Equal("true", fosJson.Get("labels.goog-terraform-provisioned").String(), "Expected goog-terraform-provisioned label to be true in labels")

        assert.False(fosJson.Get("bigtable").Exists(), "Storage type shouldn't be bigtable")
        assert.True(fosJson.Get("optimized").Exists(), "Optimized storage block should exist")

        // --- Private Service Connect Assertions ---
        pscConfigPath := "dedicatedServingEndpoint.privateServiceConnectConfig"
        assert.True(fosJson.Get(pscConfigPath+".enablePrivateServiceConnect").Bool(), "Mismatched enablePrivateServiceConnect")
        if fosJson.Get(pscConfigPath + ".projectAllowlist").Exists() {
            assert.Empty(fosJson.Get(pscConfigPath+".projectAllowlist").Array(), "PSC projectAllowlist should be empty")
        }

        // --- PSC Service Attachment ---
        serviceAttachmentOutput := fosTest.GetStringOutput("psc_service_attachment")
        apiServiceAttachment := fosJson.Get("dedicatedServingEndpoint.serviceAttachment").String()
        assert.Equal(serviceAttachmentOutput, apiServiceAttachment, "Mismatched PSC service attachment URI")
    })
    fosTest.Test()
}
