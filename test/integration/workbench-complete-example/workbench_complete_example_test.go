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

package complete_test_workbench

import (
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestCompleteWorkbench(t *testing.T) {
	vertexWorkbench := tft.NewTFBlueprintTest(t)

	vertexWorkbench.DefineVerify(func(assert *assert.Assertions) {
		vertexWorkbench.DefaultVerify(assert)

		projectId := vertexWorkbench.GetStringOutput("project_id")
		location := vertexWorkbench.GetStringOutput("location")
		workbench_name := vertexWorkbench.GetStringOutput("workbench_name")
		kmsKey := vertexWorkbench.GetStringOutput("kms_key")
		serviceAccount := vertexWorkbench.GetStringOutput("service_account")
		network := vertexWorkbench.GetStringOutput("network")
		subnet := vertexWorkbench.GetStringOutput("subnet")

		wb := gcloud.Runf(t, "workbench instances describe %s --project %s --location %s", workbench_name, projectId, location)

		assert.Equal(workbench_name, wb.Get("name").String(), "No matching name")
		assert.True(wb.Get("disableProxyAccess").Bool(), "disableProxyAccess is not set to True")
		assert.True(wb.Get("gceSetup.disablePublicIp").Bool(), "disablePublicIp is not set to True")
		assert.Equal("CMEK", wb.Get("gceSetup.bootDisk.diskEncryption").String(), "No matching boot Disk Encryption")
		assert.Equal(serviceAccount, wb.Get("gceSetup.serviceAccounts").Array()[0].Get("email").String(), "No matching serviceAccount")

		dataDisk := wb.Get("gceSetup.dataDisks").Array()[0]
		assert.Equal(kmsKey, dataDisk.Get("kmsKey").String(), "No matching data Disk kms key")
		assert.Equal("CMEK", dataDisk.Get("diskEncryption").String(), "No matching data Disk Encryption")
		assert.Equal("330", dataDisk.Get("diskSizeGb").String(), "No matching data Disk size")

		assert.Equal("test@example.com", wb.Get("gceSetup.metadata.proxy-user-mail").String(), "No matching proxy-user-mail")
		assert.Equal("00 19 * * SAT", wb.Get("gceSetup.metadata.notebook-upgrade-schedule").String(), "No matching notebook-upgrade-schedule")
		assert.Equal("download_and_run_every_start", wb.Get("gceSetup.metadata.post-startup-script-behavior").String(), "No matching post-startup-script-behavior")
		assert.Equal("3600", wb.Get("gceSetup.metadata.idle-timeout-seconds").String(), "No matching idle-timeout-seconds")
		assert.Equal("true", wb.Get("gceSetup.metadata.notebook-disable-root").String(), "No matching notebook-disable-root")
		assert.Equal("test", wb.Get("labels.env").String(), "No matching labels.env")
		assert.Equal("workbench", wb.Get("labels.type").String(), "No matching labels.type")

		assert.True(wb.Get("gceSetup.shieldedInstanceConfig.enableIntegrityMonitoring").Bool(), "enableIntegrityMonitoring is not true")
		assert.True(wb.Get("gceSetup.shieldedInstanceConfig.enableVtpm").Bool(), "enableVtpm is not true")
		assert.True(wb.Get("gceSetup.shieldedInstanceConfig.enableVtpm").Bool(), "enableVtpm is not true")

		networkInterfaces := wb.Get("gceSetup.networkInterfaces").Array()[0]
		assert.Equal("GVNIC", networkInterfaces.Get("nicType").String(), "No matching network nicType")
		assert.Equal(network, networkInterfaces.Get("network").String(), "No matching network")
		assert.Equal(subnet, networkInterfaces.Get("subnet").String(), "No matching subnet")
	})
	vertexWorkbench.Test()
}
