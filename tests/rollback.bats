#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# fallback in case command is accidentally run
export CONVOX_HOST="convox.invalid"

# simplest possible configuration
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_RACK="test-rack"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_APP="test-app"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_RELEASE="TESTRELEASE"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_VERIFY="false"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_IF_OLDER="use-rollback"

_EXPECTED_RELEASE_ID='TESTRELEASE'
_EXPECTED_ROLLBACK_ID='TESTROLLBAK'

stub_commands() {
  stub convox "releases promote --rack=test-rack --app=test-app ${_EXPECTED_RELEASE_ID} : sh -c 'echo -n \"Promoting ${_EXPECTED_RELEASE_ID}... \"; echo \"ERROR: can not promote an older release, try rollback\" >&2; exit 1'" \
              "releases rollback --rack=test-rack --app=test-app ${_EXPECTED_RELEASE_ID} : echo -e Rolling back to ${_EXPECTED_RELEASE_ID}... OK, ${_EXPECTED_ROLLBACK_ID}"
}

unstub_commands() {
  unstub convox
}

subject() {
  "$PWD/hooks/command"
}

@test "Runs the promote command with minimal required configuration" {
  stub_commands

  subject

  unstub convox
}
