#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# fallback in case command is accidentally run
export CONVOX_HOST="convox.invalid"

# simplest possible configuration
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_RACK="test-rack"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_APP="test-app"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_RELEASE="TESTRELEASE"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_VERIFY="false"

_EXPECTED_RELEASE_ID='TESTRELEASE'
_EXPECTED_PROMOTE_ARGS="releases promote --rack=test-rack --app=test-app ${_EXPECTED_RELEASE_ID}"

stub_promote() {
  stub convox "$1 : echo -e Promoting ${_EXPECTED_RELEASE_ID}... OK"
}

unstub_promote() {
  unstub convox
}

subject() {
  "$PWD/hooks/command"
}

@test "Runs the promote command with minimal required configuration" {
  stub_promote "${_EXPECTED_PROMOTE_ARGS}"

  subject

  unstub convox
}
