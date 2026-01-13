// Copyright 2025 Google LLC
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

package agent_engine_example

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
)

func TestReasoningEngineExample(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		projectID := example.GetStringOutput("project")
		if projectID == "" {
			t.Fatalf("project setup variable not found")
		}
		region := "us-central1"

		reasoningEngineID := example.GetStringOutput("reasoning_engine_id")
		reasoningEngineName := example.GetStringOutput("reasoning_engine_name")

		assert.NotEmpty(reasoningEngineID, "reasoning_engine_id output should not be empty")
		assert.NotEmpty(reasoningEngineName, "reasoning_engine_name output should not be empty")

		// Check if the ID contains project and location
		expectedIDPrefix := fmt.Sprintf("projects/%s/locations/%s/reasoningEngines/", projectID, region)
		assert.Contains(reasoningEngineID, expectedIDPrefix, "Reasoning Engine ID should contain project and location")

		services := gcloud.Run(t, "services list", gcloud.WithCommonArgs([]string{"--project", projectID, "--format", "json"})).Array()
		match := utils.GetFirstMatchResult(t, services, "config.name", "aiplatform.googleapis.com")
		assert.Equal("ENABLED", match.Get("state").String(), "Vertex AI API service (aiplatform.googleapis.com) should be enabled")

		t.Logf("Successfully verified Reasoning Engine outputs for ID: %s", reasoningEngineID)
	})

	example.Test()
}
