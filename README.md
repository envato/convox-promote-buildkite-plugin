# Convox Promote Buildkite Plugin [![Changelog](https://img.shields.io/badge/-Changelog-blue)](./CHANGELOG.md)

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) that promotes Convox Releases.

- Convox release is promoted via the Convox CLI (`convox releases promote`)
- Release IDs can be retrieved from metadata
- By default, wait for the promote to finish, then verify that the active release is the newly promoted build

## Example

The following pipeline will build and promote a release for the `test-app` app in the `test-rack` rack, equivalent to running `convox build --rack=test-rack --app=test-app` followed by `convox releases promote --rack=test-rack --app=test-app <RELEASE ID>`:

```yaml
steps:
  - plugins:
    - liamdawson/convox-build#v1.0.0:
        rack: test-rack
        app: test-app
        metadata:
          release-id: convox-release-id
  
  - wait:

  - plugins:
    - liamdawson/convox-promote#v1.0.0:
        rack: test-rack
        app: test-app
        wait: false
        release:
          metadata-key: convox-release-id
```
