# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2021-02-05

### Removed

- `wait` option: the Convox CLI defaults to waiting (and doesn't have an opt-out) since v3
  - Verification is still supported, `wait: verify` is now `verify: true`

## [1.0.0] - 2020-09-13

### Added

- Initial promote functionality
- Support for Release ID from metadata

[Unreleased]: https://github.com/liamdawson/convox-promote-buildkite-plugin/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/liamdawson/convox-promote-buildkite-plugin/releases/tag/v1.0.0...v1.1.0
[1.0.0]: https://github.com/liamdawson/convox-promote-buildkite-plugin/releases/tag/v1.0.0
