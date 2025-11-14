<p align="center"><a href="https://bearsampp.com/contribute" target="_blank"><img width="250" src="img/Bearsampp-logo.svg"></a></p>

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Bearsampp/module-composer?label=Latest%20release)
![Total downloads](https://img.shields.io/github/downloads/bearsampp/module-composer/total.svg?style=flat-square)

# Bearsampp Module - Composer

This is a module of [Bearsampp project](https://github.com/bearsampp/bearsampp) involving Composer, the PHP dependency manager.

## Documentation and Downloads

- **Module Page**: [bearsampp.com/module/composer](http://bearsampp.com/module/composer/)
- **Main Project**: [bearsampp.com](https://bearsampp.com)

## Build System

This module uses a **pure Gradle build system** for packaging Composer binaries with custom configurations.

### Quick Start

```bash
# Verify your environment
gradle verify

# List available versions
gradle listVersions

# Build a specific version
gradle release -PbundleVersion=2.8.10

# Build all versions
gradle releaseAll
```

### Requirements

| Requirement      | Version      | Notes                                    |
|------------------|--------------|------------------------------------------|
| Java             | 8 or higher  | Required for Gradle                      |
| Gradle           | 7.0+         | Included via wrapper                     |
| 7-Zip            | Any version  | Required for 7z format only              |
| Operating System | Windows      | Primary platform (Linux/macOS supported) |

### Available Tasks

| Task                                    | Description                              |
|-----------------------------------------|------------------------------------------|
| `gradle tasks`                          | List all available tasks                 |
| `gradle info`                           | Display build configuration              |
| `gradle verify`                         | Verify build environment                 |
| `gradle listVersions`                   | List available versions                  |
| `gradle release -PbundleVersion=X.X.X`  | Build specific version                   |
| `gradle releaseAll`                     | Build all versions                       |
| `gradle clean`                          | Clean build artifacts                    |

### Documentation

Comprehensive documentation is available in the [`.gradle-docs/`](.gradle-docs/) directory:

| Document                                                | Description                              |
|---------------------------------------------------------|------------------------------------------|
| [Quick Start Guide](.gradle-docs/QUICK_START.md)       | Get started in 5 minutes                 |
| [Task Reference](.gradle-docs/TASKS.md)                | Complete task documentation              |
| [Configuration Guide](.gradle-docs/CONFIG.md)          | Configuration options                    |
| [Architecture](.gradle-docs/ARCHITECTURE.md)           | Build system design                      |
| [Migration Guide](.gradle-docs/MIGRATION.md)           | Migrate from Ant to Gradle               |
| [Troubleshooting](.gradle-docs/TROUBLESHOOTING.md)     | Common issues and solutions              |
| [Examples](.gradle-docs/EXAMPLES.md)                   | Usage examples and workflows             |

### Build Output

Archives are created in the following structure:

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

### Configuration

The build system can be configured via `build.properties`:

```properties
bundle.name = composer
bundle.release = 2025.8.15
bundle.type = tools
bundle.format = 7z

# Optional: Custom build path
#build.path = C:/Bearsampp-build
```

Or via environment variables:

```bash
set BEARSAMPP_BUILD_PATH=C:\Bearsampp-build
set 7Z_HOME=C:\Program Files\7-Zip
```

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
