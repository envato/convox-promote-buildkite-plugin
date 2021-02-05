#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# fallback in case command is accidentally run
export CONVOX_HOST="convox.invalid"

# simplest possible configuration
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_RACK="test-rack"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_APP="test-app"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_RELEASE="TESTRELEASE"
export BUILDKITE_PLUGIN_CONVOX_PROMOTE_VERIFY="true"

_EXPECTED_RELEASE_ID='TESTRELEASE'
_EXPECTED_PROMOTE_ARGS="releases promote --rack=test-rack --app=test-app ${_EXPECTED_RELEASE_ID}"

subject() {
  "$PWD/hooks/command"
}

@test "Passes when the release matches latest" {
  stub convox "releases promote : echo Promoting ${_EXPECTED_RELEASE_ID}... OK" \
              "releases --rack=test-rack --app=test-app : echo -e \"\
ID           STATUS  BUILD        CREATED     DESCRIPTION\n\
${_EXPECTED_RELEASE_ID}  active  BXHXZXPXXXK  6 days ago  env add:NEW_ENV_VAR\n\
OLDRRELEASE          BXUXXXJXQXG  6 days ago\""

  subject

  unstub convox
}

@test "Fails when the release isn't the latest" {
  stub convox "releases promote : echo Promoting ${_EXPECTED_RELEASE_ID}... OK" \
              "releases --rack=test-rack --app=test-app : echo -e \"\
ID           STATUS  BUILD        CREATED     DESCRIPTION\n\
${_EXPECTED_RELEASE_ID}          BXHXZXPXXXK  6 days ago  env add:NEW_ENV_VAR\n\
OLDRRELEASE  active  BXUXXXJXQXG  6 days ago\""

  run subject

  assert_failure

  assert_line "Active release:   OLDRRELEASE"
  assert_line "Expected release: ${_EXPECTED_RELEASE_ID}"

  unstub convox
}

@test "Fails when the release isn't listed" {
  stub convox "releases promote : echo Promoting ${_EXPECTED_RELEASE_ID}... OK" \
              "releases --rack=test-rack --app=test-app : echo -e \"\
ID           STATUS  BUILD        CREATED     DESCRIPTION\n\
OTHERELEASE          BXHXZXPXXXK  6 days ago  env add:NEW_ENV_VAR\n\
OLDRRELEASE  active  BXUXXXJXQXG  6 days ago\""

  run subject

  assert_failure

  assert_line "Active release:   OLDRRELEASE"
  assert_line "Expected release: ${_EXPECTED_RELEASE_ID}"

  unstub convox
}
