## [2025-05-08] - PR#37 ([View PR](https://github.com/KennyDizi/OHA/pull/37))

### Changed
- Updated Docker run command to execute `python3 -m openhands.cli.main` in `run-open-hands.sh`.

### Added
- Added `SANDBOX_VOLUMES` environment variable to `run-open-hands.sh`, mapping the current directory to `/workspace`.

## [2025-05-08] - PR#36 ([View PR](https://github.com/KennyDizi/OHA/pull/36))

### Dependencies
- Updated:
  * `SANDBOX_RUNTIME_CONTAINER_IMAGE` from `0.36.1-nikolaik` to `0.37-nikolaik`
  * `docker.all-hands.dev/all-hands-ai/openhands` from `0.36.1` to `0.37`

## [2025-05-02] - PR#31 ([View PR](https://github.com/KennyDizi/OHA/pull/31))

### Dependencies
- Updated:
  * `SANDBOX_RUNTIME_CONTAINER_IMAGE` from `0.35-nikolaik` to `0.36-nikolaik`
  * `docker.all-hands.dev/all-hands-ai/openhands` from `0.35` to `0.36`

## [2025-04-30] - PR#28 ([View PR](https://github.com/KennyDizi/OHA/pull/28))

### Dependencies
- Updated:
  * `SANDBOX_RUNTIME_CONTAINER_IMAGE` from `0.34-nikolaik` to `0.35-nikolaik`
  - `docker.all-hands.dev/all-hands-ai/openhands` from `0.34` to `0.35`

## [2025-04-23] - PR#26 ([View PR](https://github.com/KennyDizi/OHA/pull/26))

### Changed
- Updated `SANDBOX_RUNTIME_CONTAINER_IMAGE` to `0.34-nikolaik`.
- Updated `openhands` Docker image to version `0.34` for improved consistency with new release versioning.