#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# fallback in case command is accidentally run
export CONVOX_HOST="convox.invalid"

# basic configuration
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_RACK="test-rack"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_APP="test-app"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_WAIT="false"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_RELEASE_METADATA_KEY="convox-release-id"

function setup() {
    stub buildkite-agent "meta-data get $BUILDKITE_PLUGIN_CONVOX_PROMOTE_RELEASE_METADATA_KEY : echo ${_EXPECTED_RELEASE_ID}"
}

function teardown() {
    unstub buildkite-agent
}

@test "Loads the release from meta-data" {
  stub convox "releases promote --rack=test-rack --app=test-app ${_EXPECTED_RELEASE_ID} : echo -e Promoting ${_EXPECTED_RELEASE_ID}... OK"

  "$PWD/hooks/command"

  unstub convox
}
