// Copyright 2026 Google LLC
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

package semantic_governance_policy_engine_gateway_test

import (
	"strings"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

// TestSemanticGovernancePolicyEngineGatewayExample applies the example, which
// provisions a Semantic Governance Policy Engine with one Private Service
// Connect gateway into a customer VPC.
func TestSemanticGovernancePolicyEngineGatewayExample(t *testing.T) {
	gw := tft.NewTFBlueprintTest(t)

	gw.DefineVerify(func(assert *assert.Assertions) {
		// Re-plans and fails on any diff. The example passes network and
		// subnetwork as resource ids because the self_link form churns.
		gw.DefaultVerify(assert)

		endpoints := gw.GetJsonOutput("gateway_endpoints").Array()
		if !assert.Len(endpoints, 1, "expected one gateway") {
			return
		}
		ep := endpoints[0]

		// A FAILED gateway doesn't fail the apply; the engine can still be
		// ACTIVE, so check the gateway's own state.
		assert.Equal("ACTIVE", ep.Get("state").String(), "gateway should be ACTIVE")

		// The engine publishes the gateway's A-record into the example's
		// private zone once the gateway is ACTIVE.
		dnsRecord := ep.Get("dns_record").String()
		assert.True(strings.HasSuffix(dnsRecord, ".internal.sgp.local."), "dns_record %q should be in the example's private zone", dnsRecord)
		assert.NotEmpty(ep.Get("psc_endpoint").String(), "gateway should have a PSC endpoint")
	})

	gw.Test()
}
