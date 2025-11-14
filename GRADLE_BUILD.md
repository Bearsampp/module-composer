# Gradle Build System

This project uses a **pure Gradle build system** for packaging Composer modules.

## Quick Reference

### Common Commands

| Command                                    | Description                              |
|--------------------------------------------|------------------------------------------|
| `gradle tasks`                             | List all available tasks                 |
| `gradle info`                              | Display build configuration              |
| `gradle verify`                            | Verify build environment                 |
| `gradle listVersions`                      | List available versions                  |
| `gradle release -PbundleVersion=2.8.10`    | Build specific version                   |
| `gradle releaseAll`                        | Build all versions                       |
| `gradle clean`                             | Clean build artifacts                    |

### Requirements

| Requirement      | Version      | Check Command              |
|------------------|--------------|----------------------------|
| Java             | 8 or higher  | `java -version`            |
| Gradle           | 7.0+         | `gradle --version`         |
| 7-Zip            | Any version  | Check Program Files        |

### Quick Start

```bash
# 1. Verify environment
gradle verify

# 2. List available versions
gradle listVersions

# 3. Build a release
gradle release -PbundleVersion=2.8.10
```

## Documentation

Comprehensive documentation is available in the **[`.gradle-docs/`](.gradle-docs/)** directory:

### Getting Started

| Document                                                | Description                              |
|---------------------------------------------------------|------------------------------------------|
| [README](.gradle-docs/README.md)                        | Documentation overview                   |
| [Quick Start Guide](.gradle-docs/QUICK_START.md)       | Get started in 5 minutes                 |
| [Task Reference](.gradle-docs/TASKS.md)                | Complete task documentation              |

### Configuration

| Document                                                | Description                              |
|---------------------------------------------------------|------------------------------------------|
| [Configuration Guide](.gradle-docs/CONFIG.md)          | Configuration options and properties     |
| [Architecture](.gradle-docs/ARCHITECTURE.md)           | Build system design and architecture     |

### Migration & Support

| Document                                                | Description                              |
|---------------------------------------------------------|------------------------------------------|
| [Migration Guide](.gradle-docs/MIGRATION.md)           | Migrate from Ant to Gradle               |
| [Troubleshooting](.gradle-docs/TROUBLESHOOTING.md)     | Common issues and solutions              |
| [Examples](.gradle-docs/EXAMPLES.md)                   | Usage examples and workflows             |

### Historical Documentation

| Document                                                | Description                              |
|---------------------------------------------------------|------------------------------------------|
| [Gradle Updates](.gradle-docs/GRADLE_UPDATES.md)       | Detailed changelog of Gradle migration   |
| [Changes Summary](.gradle-docs/CHANGES_SUMMARY.md)     | High-level summary of changes            |
| [Sync Complete](.gradle-docs/GRADLE_SYNC_COMPLETE.md)  | Migration completion report              |

## Configuration Files

| File                  | Purpose                                  |
|-----------------------|------------------------------------------|
| `build.gradle`        | Main build script                        |
| `settings.gradle`     | Project settings                         |
| `build.properties`    | Bundle configuration                     |
| `gradle.properties`   | Gradle daemon and JVM settings           |
| `releases.properties` | Composer version to URL mappings         |

## Build Output

Archives are created in:

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

## Key Features

### Pure Gradle Build
- ✅ No Ant dependencies
- ✅ Modern build system
- ✅ Better IDE integration
- ✅ Cross-platform support

### Flexible Configuration
- ✅ Configurable build paths (3-level priority)
- ✅ Environment variable support
- ✅ Interactive and non-interactive modes

### Version Management
- ✅ Automatic version discovery
- ✅ Support for bin/ and bin/archived/
- ✅ Batch processing (build all versions)

### Quality Assurance
- ✅ Environment verification
- ✅ Property validation
- ✅ Automatic hash generation (MD5, SHA1, SHA256, SHA512)

## Configuration Examples

### Basic Configuration

**build.properties:**
```properties
bundle.name = composer
bundle.release = 2025.8.15
bundle.type = tools
bundle.format = 7z
```

### Custom Build Path

**Option 1 - build.properties:**
```properties
build.path = C:/Bearsampp-build
```

**Option 2 - Environment Variable:**
```bash
set BEARSAMPP_BUILD_PATH=C:\Bearsampp-build
```

### Custom 7-Zip Location

```bash
set 7Z_HOME=C:\Program Files\7-Zip
```

## Task Groups

### Build Tasks
- `release` - Build release package for specific version
- `releaseAll` - Build all available versions
- `clean` - Clean build artifacts
- `downloadComposer` - Download Composer PHAR file

### Help Tasks
- `info` - Display build configuration
- `listVersions` - List available versions
- `listReleases` - List releases from properties file

### Verification Tasks
- `verify` - Verify build environment
- `validateProperties` - Validate configuration

## Support

### Documentation
- Read the [Quick Start Guide](.gradle-docs/QUICK_START.md)
- Check [Troubleshooting](.gradle-docs/TROUBLESHOOTING.md)
- Review [Examples](.gradle-docs/EXAMPLES.md)

### Community
- **Issues**: [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues)
- **Website**: [bearsampp.com](https://bearsampp.com)
- **Module Page**: [bearsampp.com/module/composer](http://bearsampp.com/module/composer/)

## Migration from Ant

If you're migrating from the old Ant build system, see the [Migration Guide](.gradle-docs/MIGRATION.md).

### Quick Migration

1. **Verify environment:**
   ```bash
   gradle verify
   ```

2. **Test build:**
   ```bash
   gradle release -PbundleVersion=2.8.10
   ```

3. **Remove Ant files:**
   - `build.xml` has been removed
   - `build.properties` is still used (compatible with both)

## Troubleshooting

### Common Issues

| Issue                  | Solution                                 |
|------------------------|------------------------------------------|
| Java not found         | Install Java 8+ and add to PATH          |
| Gradle not found       | Use Gradle wrapper: `gradlew`            |
| 7-Zip not found        | Install 7-Zip or use ZIP format          |
| Version not found      | Run `gradle listVersions`                |

See the complete [Troubleshooting Guide](.gradle-docs/TROUBLESHOOTING.md) for more solutions.

## Version History

| Version   | Date       | Changes                                  |
|-----------|------------|------------------------------------------|
| 2025.8.15 | 2025-01-15 | Pure Gradle build implementation         |
| 2025.8.15 | 2025-01-15 | Comprehensive documentation added        |
| 2025.8.15 | 2025-01-15 | Ant build system removed                 |

---

**Get Started**: Run `gradle verify` to check your environment, then see the [Quick Start Guide](.gradle-docs/QUICK_START.md).
