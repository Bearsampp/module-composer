<p align="center"><a href="https://bearsampp.com/contribute" target="_blank"><img width="250" src="img/Bearsampp-logo.svg"></a></p>

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Bearsampp/module-composer?label=Latest%20release)
![Total downloads](https://img.shields.io/github/downloads/bearsampp/module-composer/total.svg?style=flat-square)

# Bearsampp Module - Composer

This is a module of [Bearsampp project](https://github.com/bearsampp/bearsampp) involving Composer, the PHP dependency manager.

## Documentation and Downloads

- **Module Page**: [bearsampp.com/module/composer](http://bearsampp.com/module/composer/)
- **Main Project**: [bearsampp.com](https://bearsampp.com)

## Build System

This project uses **Gradle** as its build system. The legacy Ant build has been fully replaced with a modern, pure Gradle implementation.

### Quick Start

```bash
# Display build information
gradle info

# List all available tasks
gradle tasks

# Verify build environment
gradle verify

# Build a release (interactive)
gradle release

# Build a specific version (non-interactive)
gradle release -PbundleVersion=2.8.10

# Clean build artifacts
gradle clean
```

### Prerequisites

| Requirement       | Version       | Purpose                                  |
|-------------------|---------------|------------------------------------------|
| **Java**          | 8+            | Required for Gradle execution            |
| **Gradle**        | 8.0+          | Build automation tool                    |
| **7-Zip**         | Latest        | Archive creation (optional for zip)      |

### Available Tasks

| Task                  | Description                                      |
|-----------------------|--------------------------------------------------|
| `release`             | Build release package (interactive/non-interactive) |
| `clean`               | Clean build artifacts and temporary files        |
| `verify`              | Verify build environment and dependencies        |
| `info`                | Display build configuration information          |
| `listVersions`        | List available bundle versions in bin/           |
| `listReleases`        | List available releases from modules-untouched   |
| `validateProperties`  | Validate build.properties configuration          |

For complete documentation, see [.gradle-docs/README.md](.gradle-docs/README.md)

## Documentation

- **Build Documentation**: [.gradle-docs/README.md](.gradle-docs/README.md)
- **Task Reference**: [.gradle-docs/TASKS.md](.gradle-docs/TASKS.md)
- **Configuration Guide**: [.gradle-docs/CONFIG.md](.gradle-docs/CONFIG.md)
- **Module Downloads**: https://bearsampp.com/module/composer

## Issues

Issues must be reported on [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues).

## Contributing

Contributions are welcome! Please ensure:

1. All tasks pass verification: `gradle verify`
2. Documentation is updated for new features
3. Code follows existing patterns and conventions
4. Changes are tested on Windows platform

## License

This project is part of the Bearsampp project. See [LICENSE](LICENSE) for details.

## Statistics

![Alt](https://repobeats.axiom.co/api/embed/ed088a0bc7d3a54504ceed76595139a6acbae65d.svg "Repobeats analytics image")
