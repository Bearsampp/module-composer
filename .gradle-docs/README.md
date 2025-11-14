# Bearsampp Module Composer - Gradle Build Documentation

## Overview

This directory contains comprehensive documentation for the Gradle build system used in the Bearsampp Composer module. The build system provides a pure Gradle implementation for packaging Composer binaries with custom configurations.

## Documentation Structure

| Document                                     | Description                                              |
|----------------------------------------------|----------------------------------------------------------|
| [README.md](README.md)                       | This file - documentation overview                       |
| [QUICK_START.md](QUICK_START.md)            | Quick start guide for building releases                  |
| [TASKS.md](TASKS.md)                         | Complete reference of all Gradle tasks                   |
| [CONFIG.md](CONFIG.md)                       | Configuration options and build properties               |
| [ARCHITECTURE.md](ARCHITECTURE.md)           | Build system architecture and design                     |
| [MIGRATION.md](MIGRATION.md)                 | Migration guide from Ant to Gradle                       |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md)     | Common issues and solutions                              |
| [EXAMPLES.md](EXAMPLES.md)                   | Usage examples and workflows                             |

## Quick Links

### Getting Started
- [Quick Start Guide](QUICK_START.md) - Get up and running in 5 minutes
- [Configuration Guide](CONFIG.md) - Configure your build environment
- [Task Reference](TASKS.md) - Learn about available tasks

### Advanced Topics
- [Architecture](ARCHITECTURE.md) - Understand the build system design
- [Migration Guide](MIGRATION.md) - Migrate from Ant to Gradle
- [Troubleshooting](TROUBLESHOOTING.md) - Solve common problems

### Examples
- [Usage Examples](EXAMPLES.md) - Real-world build scenarios

## Key Features

### Pure Gradle Build
- **No Ant dependencies** - Complete Gradle implementation
- **Modern build system** - Leverages Gradle's powerful features
- **Cross-platform** - Works on Windows, Linux, and macOS

### Flexible Configuration
- **Configurable build paths** - Three-level priority system
- **Environment variables** - Override settings via environment
- **Build properties** - Centralized configuration file

### Version Management
- **Automatic detection** - Finds versions in bin/ and bin/archived/
- **Interactive mode** - Select versions from a menu
- **Batch processing** - Build all versions at once

### Archive Generation
- **Multiple formats** - Support for 7z and zip
- **Hash generation** - Automatic MD5, SHA1, SHA256, SHA512
- **Consistent naming** - Standard Bearsampp naming convention

### Quality Assurance
- **Environment verification** - Check prerequisites before building
- **Property validation** - Ensure configuration is correct
- **Comprehensive logging** - Detailed build output

## System Requirements

| Requirement      | Version      | Notes                                    |
|------------------|--------------|------------------------------------------|
| Java             | 8 or higher  | Required for Gradle                      |
| Gradle           | 7.0+         | Included via wrapper                     |
| 7-Zip            | Any version  | Required for 7z format only              |
| Operating System | Windows      | Primary platform (Linux/macOS supported) |

## Build Output Structure

```
bearsampp-build/
└── tools/
    └── composer/
        └── {release}/
            ├── bearsampp-composer-{version}-{release}.7z
            ├── bearsampp-composer-{version}-{release}.7z.md5
            ├── bearsampp-composer-{version}-{release}.7z.sha1
            ├── bearsampp-composer-{version}-{release}.7z.sha256
            └── bearsampp-composer-{version}-{release}.7z.sha512
```

## Common Commands

| Command                                      | Description                              |
|----------------------------------------------|------------------------------------------|
| `gradle tasks`                               | List all available tasks                 |
| `gradle info`                                | Display build configuration              |
| `gradle verify`                              | Verify build environment                 |
| `gradle listVersions`                        | List available versions                  |
| `gradle release -PbundleVersion=2.8.10`      | Build specific version                   |
| `gradle releaseAll`                          | Build all versions                       |
| `gradle clean`                               | Clean build artifacts                    |

## Support

### Documentation
- Read the [Quick Start Guide](QUICK_START.md) for immediate help
- Check [Troubleshooting](TROUBLESHOOTING.md) for common issues
- Review [Examples](EXAMPLES.md) for usage patterns

### Community
- **Issues**: Report on [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues)
- **Website**: [bearsampp.com](https://bearsampp.com)
- **Module Page**: [bearsampp.com/module/composer](http://bearsampp.com/module/composer/)

## Contributing

Contributions are welcome! Please ensure:
1. All tasks pass verification: `gradle verify`
2. Documentation is updated for new features
3. Code follows existing patterns and conventions
4. Changes are tested on Windows platform

## License

This project is part of the Bearsampp project. See [LICENSE](../LICENSE) for details.

## Version History

| Version   | Date       | Changes                                  |
|-----------|------------|------------------------------------------|
| 2025.8.15 | 2025-01-15 | Pure Gradle build implementation         |
| 2025.8.15 | 2025-01-15 | Comprehensive documentation added        |

---

**Next Steps**: Start with the [Quick Start Guide](QUICK_START.md) to build your first release.
