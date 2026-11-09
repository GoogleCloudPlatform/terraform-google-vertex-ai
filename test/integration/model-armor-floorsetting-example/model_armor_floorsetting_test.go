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
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestModelArmorFloorsetting(t *testing.T) {
	modelArmorFloorsetting := tft.NewTFBlueprintTest(t)

	modelArmorFloorsetting.DefineVerify(func(assert *assert.Assertions) {
		modelArmorFloorsetting.DefaultVerify(assert)

		projectId := modelArmorFloorsetting.GetStringOutput("project_id")
		id := modelArmorFloorsetting.GetStringOutput("id")
		name := modelArmorFloorsetting.GetStringOutput("name")
		parent := modelArmorFloorsetting.GetStringOutput("parent")
		createTime := modelArmorFloorsetting.GetStringOutput("create_time")
		updateTime := modelArmorFloorsetting.GetStringOutput("update_time")

		mafs := gcloud.Runf(t, "model-armor floorsettings describe --full-uri=projects/%s/locations/global/floorSetting", projectId)
		fmt.Println(mafs)

		assert.Equal(fmt.Sprintf("projects/%s/locations/global/floorSetting", projectId), id, "No matching id")
		assert.Equal(mafs.Get("name").String(), name, "No matching name")
		assert.Equal(fmt.Sprintf("projects/%s", projectId), parent, "No matching parent")
		assert.NotEmpty(createTime, "create_time output should not be empty")
		assert.Equal(mafs.Get("createTime").String(), createTime, "No matching createTime")
		assert.NotEmpty(updateTime, "update_time output should not be empty")
		assert.Equal(mafs.Get("updateTime").String(), updateTime, "No matching updateTime")

		assert.True(mafs.Get("enableFloorSettingEnforcement").Bool(), "enableFloorSettingEnforcement is not set to True")

		assert.True(mafs.Get("aiPlatformFloorSetting.enableCloudLogging").Bool(), "aiPlatformFloorSetting.enableCloudLogging is not set to True")
		assert.True(mafs.Get("aiPlatformFloorSetting.inspectAndBlock").Bool(), "aiPlatformFloorSetting.inspectAndBlock is not set to True")

		assert.True(mafs.Get("googleMcpServerFloorSetting.inspectAndBlock").Bool(), "googleMcpServerFloorSetting.inspectAndBlock is not set to True")

		assert.True(mafs.Get("floorSettingMetadata.multiLanguageDetection.enableMultiLanguageDetection").Bool(), "floorSettingMetadata.multiLanguageDetection.enableMultiLanguageDetection is not set to True")

		assert.Equal("ENABLED", mafs.Get("filterConfig.sdpSettings.basicConfig.filterEnforcement").String(), "No matching filterConfig.sdpSettings.basicConfig.filterEnforcement")
		assert.Equal("MEDIUM_AND_ABOVE", mafs.Get("filterConfig.piAndJailbreakFilterSettings.confidenceLevel").String(), "No matching filterConfig.piAndJailbreakFilterSettings.confidenceLevel")
		assert.Equal("ENABLED", mafs.Get("filterConfig.piAndJailbreakFilterSettings.filterEnforcement").String(), "No matching filterConfig.piAndJailbreakFilterSettings.filterEnforcement")
		assert.Equal("ENABLED", mafs.Get("filterConfig.maliciousUriFilterSettings.filterEnforcement").String(), "No matching filterConfig.maliciousUriFilterSettings.filterEnforcement")
		assert.Len(mafs.Get("filterConfig.raiSettings.raiFilters").Array(), 2, "Expected 2 configured RAI filters")
		assert.Equal("LOW_AND_ABOVE", mafs.Get("filterConfig.raiSettings.raiFilters.#(filterType==\"DANGEROUS\").confidenceLevel").String(), "No matching DANGEROUS RAI filter confidenceLevel")
		assert.Equal("MEDIUM_AND_ABOVE", mafs.Get("filterConfig.raiSettings.raiFilters.#(filterType==\"SEXUALLY_EXPLICIT\").confidenceLevel").String(), "No matching SEXUALLY_EXPLICIT RAI filter confidenceLevel")
	})
	modelArmorFloorsetting.Test()
}
