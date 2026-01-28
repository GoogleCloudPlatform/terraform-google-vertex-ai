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

package model_armor_floorsetting_test

import (
	"testing"
	"fmt"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestModelArmorFloorsetting(t *testing.T) {
	modelArmorFloorsetting := tft.NewTFBlueprintTest(t)

	modelArmorFloorsetting.DefineVerify(func(assert *assert.Assertions) {
		modelArmorFloorsetting.DefaultVerify(assert)

		projectId := modelArmorFloorsetting.GetStringOutput("project_id")


		mafs := gcloud.Runf(t, "model-armor floorsettings describe --full-uri=projects/%s/locations/global/floorSetting", projectId)
		fmt.Println(mafs)


		assert.True(mafs.Get("enableFloorSettingEnforcement").Bool(), "enableFloorSettingEnforcement is not set to True")

		assert.True(mafs.Get("aiPlatformFloorSetting.enableCloudLogging").Bool(), "aiPlatformFloorSetting.enableCloudLogging is not set to True")
		assert.True(mafs.Get("aiPlatformFloorSetting.inspectAndBlock").Bool(), "aiPlatformFloorSetting.inspectAndBlock is not set to True")

		assert.True(mafs.Get("googleMcpServerFloorSetting.inspectAndBlock").Bool(), "googleMcpServerFloorSetting.inspectAndBlock is not set to True")

		assert.True(mafs.Get("floorSettingMetadata.multiLanguageDetection.enableMultiLanguageDetection").Bool(), "floorSettingMetadata.multiLanguageDetection.enableMultiLanguageDetection is not set to True")

		assert.Equal("ENABLED", mafs.Get("filterConfig.sdpSettings.basicConfig.filterEnforcement").String(), "No matching filterConfig.sdpSettings.basicConfig.filterEnforcement")
		assert.Equal("MEDIUM_AND_ABOVE", mafs.Get("filterConfig.piAndJailbreakFilterSettings.confidenceLevel").String(), "No matching filterConfig.piAndJailbreakFilterSettings.confidenceLevel")
		assert.Equal("ENABLED", mafs.Get("filterConfig.piAndJailbreakFilterSettings.filterEnforcement").String(), "No matching filterConfig.piAndJailbreakFilterSettings.filterEnforcement")
		assert.Equal("ENABLED", mafs.Get("filterConfig.sdpSettings.basicConfig.filterEnforcement").String(), "No matching filterConfig.sdpSettings.basicConfig.filterEnforcement")
	})
	modelArmorFloorsetting.Test()
}
