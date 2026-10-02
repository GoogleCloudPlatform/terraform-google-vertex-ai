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

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

// TestSemanticGovernancePolicy applies the example, which provisions a Semantic
// Governance Policy Engine, an agent, and a policy for that agent, so it covers
// both the semantic-governance-policy and semantic-governance-policy-engine
// modules. The API rejects a policy create unless the engine is ACTIVE, so a
// successful apply also proves the engine provisioned.
func TestSemanticGovernancePolicy(t *testing.T) {
	sgp := tft.NewTFBlueprintTest(t)

	sgp.DefineVerify(func(assert *assert.Assertions) {
		// Re-plans and fails on any diff, which catches perpetual-diff bugs in
		// either module.
		sgp.DefaultVerify(assert)

		name := sgp.GetStringOutput("name")
		assert.Contains(name, "/semanticGovernancePolicies/no-internal-endpoints", "unexpected policy name %q", name)

		// agent_identity is computed by the server from the agent's Agent
		// Registry entry, so a value here shows the policy round-tripped.
		agentIdentity := sgp.GetStringOutput("agent_identity")
		assert.True(strings.HasPrefix(agentIdentity, "principal://"), "unexpected agent_identity %q", agentIdentity)
	})

	sgp.Test()
}
