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

package model_armor_template_test

import (
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestModelArmorTemplate(t *testing.T) {
	modelArmorTemplate := tft.NewTFBlueprintTest(t)

	modelArmorTemplate.DefineVerify(func(assert *assert.Assertions) {
		modelArmorTemplate.DefaultVerify(assert)

		projectId := modelArmorTemplate.GetStringOutput("project_id")
		location := modelArmorTemplate.GetStringOutput("location")
		name := modelArmorTemplate.GetStringOutput("name")
		templateId := modelArmorTemplate.GetStringOutput("template_id")


		mat := gcloud.Runf(t, "model-armor templates describe %s --project %s --location %s", templateId, projectId, location)

		assert.Equal(name, mat.Get("name").String(), "No matching name")
		assert.Equal("bar", mat.Get("labels.foo").String(), "No matching labels.foo")

		assert.Equal("798", mat.Get("templateMetadata.customLlmResponseSafetyErrorCode").String(), "No matching templateMetadata.customLlmResponseSafetyErrorCode")
		assert.Equal("error 798", mat.Get("templateMetadata.customLlmResponseSafetyErrorMessage").String(), "No matching templateMetadata.customLlmResponseSafetyErrorMessage")
		assert.Equal("799", mat.Get("templateMetadata.customPromptSafetyErrorCode").String(), "No matching templateMetadata.customPromptSafetyErrorCode")
		assert.Equal("error 799", mat.Get("templateMetadata.customPromptSafetyErrorMessage").String(), "No matching templateMetadata.customPromptSafetyErrorMessage")
		assert.Equal("INSPECT_AND_BLOCK", mat.Get("templateMetadata.enforcementType").String(), "No matching templateMetadata.enforcementType")
		assert.True(mat.Get("templateMetadata.logSanitizeOperations").Bool(), "templateMetadata.logSanitizeOperations is not set to True")
		assert.True(mat.Get("templateMetadata.multiLanguageDetection.enableMultiLanguageDetection").Bool(), "templateMetadata.logSanitizeOperations is not set to True")

		assert.Equal("ENABLED", mat.Get("filterConfig.sdpSettings.basicConfig.filterEnforcement").String(), "No matching filterConfig.sdpSettings.basicConfig.filterEnforcement")
		assert.Equal("ENABLED", mat.Get("filterConfig.maliciousUriFilterSettings.filterEnforcement").String(), "No matching filterConfig.maliciousUriFilterSettings.filterEnforcement")
		assert.Equal("MEDIUM_AND_ABOVE", mat.Get("filterConfig.piAndJailbreakFilterSettings.confidenceLevel").String(), "No matching filterConfig.piAndJailbreakFilterSettings.confidenceLevel")
		assert.Equal("ENABLED", mat.Get("filterConfig.piAndJailbreakFilterSettings.filterEnforcement").String(), "No matching filterConfig.maliciousUriFilterSettings.filterEnforcement")
	})
	modelArmorTemplate.Test()
}
