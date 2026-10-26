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

package semantic_governance_policy_test

import (
	"strings"
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

// TestSemanticGovernancePolicyExample applies the example, which provisions a
// Semantic Governance Policy Engine, an agent, and a policy for that agent, so
// it covers both the semantic-governance-policy and
// semantic-governance-policy-engine modules.
func TestSemanticGovernancePolicyExample(t *testing.T) {
	sgp := tft.NewTFBlueprintTest(t,
		// Agent Registry lists a new agent asynchronously, and the example's
		// lookup fails outright if the agent isn't listed yet. Re-running the
		// apply re-reads the lookup without recreating anything.
		tft.WithRetryableTerraformErrors(map[string]string{
			".*did not find an Agent.*": "Agent Registry has not listed the new agent yet",
		}, 5, time.Minute),
	)

	sgp.DefineVerify(func(assert *assert.Assertions) {
		// Re-plans and fails on any diff, which catches perpetual-diff bugs in
		// either module.
		sgp.DefaultVerify(assert)

		name := sgp.GetStringOutput("name")
		assert.Contains(name, "/locations/us-central1/semanticGovernancePolicies/no-internal-endpoints", "unexpected policy name %q", name)

		// The API rejects a policy create unless the engine is ACTIVE, and the
		// example orders the policy after the engine through module_depends_on.
		assert.Equal("ACTIVE", sgp.GetStringOutput("engine_state"), "engine should be ACTIVE")

		// These come back from the server, so they show the module sent the
		// agent and the denial message and the policy stored them.
		assert.Equal(sgp.GetStringOutput("registry_agent"), sgp.GetStringOutput("agent"), "policy should govern the example's agent")
		assert.Equal("This request was blocked because it targets an internal developer endpoint.", sgp.GetStringOutput("denial_message"), "denial message should be stored on the policy")

		// agent_identity is computed by the server from the agent's Agent
		// Registry entry.
		agentIdentity := sgp.GetStringOutput("agent_identity")
		assert.True(strings.HasPrefix(agentIdentity, "principal://"), "unexpected agent_identity %q", agentIdentity)
	})

	sgp.Test()
}
