# Bearsampp Module Composer - Gradle Build Documentation

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Build Tasks](#build-tasks)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Troubleshooting](#troubleshooting)
- [Migration Guide](#migration-guide)

---

## Overview

The Bearsampp Module Composer project has been converted to a **pure Gradle build system**, replacing the legacy Ant build configuration. This provides:

- **Modern Build System**     - Native Gradle tasks and conventions
- **Better Performance**       - Incremental builds and caching
- **Simplified Maintenance**   - Pure Groovy/Gradle DSL
- **Enhanced Tooling**         - IDE integration and dependency management
- **Cross-Platform Support**   - Works on Windows, Linux, and macOS

### Project Information

| Property          | Value                                    |
|-------------------|------------------------------------------|
| **Project Name**  | module-composer                          |
| **Group**         | com.bearsampp.modules                    |
| **Type**          | Composer Module Builder                  |
| **Build Tool**    | Gradle 8.x+                              |
| **Language**      | Groovy (Gradle DSL)                      |

---

## Quick Start

### Prerequisites

| Requirement       | Version       | Purpose                                  |
|-------------------|---------------|------------------------------------------|
| **Java**          | 8+            | Required for Gradle execution            |
| **Gradle**        | 8.0+          | Build automation tool                    |
| **7-Zip**         | Latest        | Archive creation (optional for zip)      |

### Basic Commands

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

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/bearsampp/module-composer.git
cd module-composer
```

### 2. Verify Environment

```bash
gradle verify
```

This will check:
- Java version (8+)
- Required files (build.properties)
- Directory structure (bin/)
- Build dependencies

### 3. List Available Versions

```bash
gradle listVersions
```

### 4. Build Your First Release

```bash
# Interactive mode (prompts for version)
gradle release

# Or specify version directly
gradle release -PbundleVersion=2.8.10
```

---

## Build Tasks

### Core Build Tasks

| Task                  | Description                                      | Example                                  |
|-----------------------|--------------------------------------------------|------------------------------------------|
| `release`             | Build and package release (interactive/non-interactive) | `gradle release -PbundleVersion=2.8.10` |
| `releaseAll`          | Build all available versions                     | `gradle releaseAll`                      |
| `clean`               | Clean build artifacts and temporary files        | `gradle clean`                           |

### Verification Tasks

| Task                      | Description                                  | Example                                      |
|---------------------------|----------------------------------------------|----------------------------------------------|
| `verify`                  | Verify build environment and dependencies    | `gradle verify`                              |
| `validateProperties`      | Validate build.properties configuration      | `gradle validateProperties`                  |

### Information Tasks

| Task                | Description                                      | Example                    |
|---------------------|--------------------------------------------------|----------------------------|
| `info`              | Display build configuration information          | `gradle info`              |
| `listVersions`      | List available bundle versions in bin/           | `gradle listVersions`      |
| `listReleases`      | List all available releases from modules-untouched | `gradle listReleases`  |
| `checkModulesUntouched` | Check modules-untouched integration          | `gradle checkModulesUntouched` |

### Task Groups

| Group            | Purpose                                          |
|------------------|--------------------------------------------------|
| **build**        | Build and package tasks                          |
| **verification** | Verification and validation tasks                |
| **help**         | Help and information tasks                       |

---

## Configuration

### build.properties

The main configuration file for the build:

```properties
bundle.name     = composer
bundle.release  = 2025.8.15
bundle.type     = tools
bundle.format   = 7z
```

| Property          | Description                          | Example Value  |
|-------------------|--------------------------------------|----------------|
| `bundle.name`     | Name of the bundle                   | `composer`     |
| `bundle.release`  | Release version                      | `2025.8.15`    |
| `bundle.type`     | Type of bundle                       | `tools`        |
| `bundle.format`   | Archive format                       | `7z`           |

### gradle.properties

Gradle-specific configuration:

```properties
# Gradle daemon configuration
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true

# JVM settings
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m
```

### Directory Structure

```
module-composer/
├── .gradle-docs/          # Gradle documentation
│   ├── README.md          # Main documentation
│   ├── TASKS.md           # Task reference
│   ├── CONFIG.md          # Configuration guide
│   ├── ARCHITECTURE.md    # Architecture overview
│   ├── MIGRATION.md       # Migration guide
│   ├── TROUBLESHOOTING.md # Troubleshooting guide
│   └── EXAMPLES.md        # Usage examples
├── bin/                   # Composer version bundles
│   ├── composer2.8.10/
│   ├── composer2.8.9/
│   └── ...
bearsampp-build/                    # External build directory (outside repo)
├── tmp/                            # Temporary build files
│   ├── bundles_prep/tools/composer/  # Prepared bundles
│   ├── bundles_build/tools/composer/ # Build staging
│   ├── downloads/composer/           # Downloaded dependencies
│   └── extract/composer/             # Extracted archives
└── tools/composer/                   # Final packaged archives
    └── 2025.8.15/                    # Release version
        ├── bearsampp-composer-2.8.10-2025.8.15.7z
        ├── bearsampp-composer-2.8.10-2025.8.15.7z.md5
        └── ...
├── build.gradle           # Main Gradle build script
├── settings.gradle        # Gradle settings
└── build.properties       # Build configuration
```

---

## Architecture

### Build Process Flow

```
1. User runs: gradle release -PbundleVersion=2.8.10
                    ↓
2. Validate environment and version
                    ↓
3. Create preparation directory (tmp/prep/)
                    ↓
4. Download composer.phar from modules-untouched repository
   - Check modules-untouched composer.properties
   - Fallback to standard URL format
                    ↓
5. Copy base Composer files from bin/composer2.8.10/
   - composer.bat
   - composer.json
   - bearsampp.conf
                    ↓
6. Copy composer.phar to preparation directory
                    ↓
7. Output prepared bundle to tmp/prep/
                    ↓
8. Copy to bundles_build for non-compressed version
                    ↓
9. Package prepared folder into archive in bearsampp-build/tools/composer/{bundle.release}/
   - The archive includes the top-level folder: composer{version}/
```

### Packaging Details

- **Archive name format**: `bearsampp-composer-{version}-{bundle.release}.{7z|zip}`
- **Location**: `bearsampp-build/tools/composer/{bundle.release}/`
  - Example: `bearsampp-build/tools/composer/2025.8.15/bearsampp-composer-2.8.10-2025.8.15.7z`
- **Content root**: The top-level folder inside the archive is `composer{version}/` (e.g., `composer2.8.10/`)
- **Structure**: The archive contains the Composer version folder at the root with all Composer files inside

**Archive Structure Example**:
```
bearsampp-composer-2.8.10-2025.8.15.7z
└── composer2.8.10/         ← Version folder at root
    ├── composer.bat
    ├── composer.phar
    ├── composer.json
    ├── bearsampp.conf
    └── ...
```

**Verification Commands**:

```bash
# List archive contents with 7z
7z l bearsampp-build/tools/composer/2025.8.15/bearsampp-composer-2.8.10-2025.8.15.7z | more

# You should see entries beginning with:
#   composer2.8.10/composer.bat
#   composer2.8.10/composer.phar
#   composer2.8.10/composer.json
#   composer2.8.10/...

# Extract and inspect with PowerShell (zip example)
Expand-Archive -Path bearsampp-build/tools/composer/2025.8.15/bearsampp-composer-2.8.10-2025.8.15.zip -DestinationPath .\_inspect
Get-ChildItem .\_inspect\composer2.8.10 | Select-Object Name

# Expected output:
#   composer.bat
#   composer.phar
#   composer.json
#   bearsampp.conf
#   ...
```

**Note**: This archive structure matches the PHP module pattern where archives contain `php{version}/` at the root. This ensures consistency across all Bearsampp modules.

**Hash Files**: Each archive is accompanied by hash sidecar files:
- `.md5` - MD5 checksum
- `.sha1` - SHA-1 checksum
- `.sha256` - SHA-256 checksum
- `.sha512` - SHA-512 checksum

Example:
```
bearsampp-build/tools/composer/2025.8.15/
├── bearsampp-composer-2.8.10-2025.8.15.7z
├── bearsampp-composer-2.8.10-2025.8.15.7z.md5
├── bearsampp-composer-2.8.10-2025.8.15.7z.sha1
├── bearsampp-composer-2.8.10-2025.8.15.7z.sha256
└── bearsampp-composer-2.8.10-2025.8.15.7z.sha512
```

### Composer PHAR Download

The build system downloads composer.phar from the modules-untouched repository:

**Version Resolution Strategy**:
1. Check `modules-untouched` composer.properties (remote)
2. Construct standard URL format (fallback)

**modules-untouched URL**:
```
https://raw.githubusercontent.com/Bearsampp/modules-untouched/main/modules/composer.properties
```

**Standard URL Format (fallback)**:
```
https://getcomposer.org/download/{version}/composer.phar
```

---

## Troubleshooting

### Common Issues

#### Issue: "Dev path not found"

**Symptom:**
```
Dev path not found: E:/Bearsampp-development/dev
```

**Solution:**
This is a warning only. The dev path is optional for most tasks. If you need it, ensure the `dev` project exists in the parent directory.

---

#### Issue: "Bundle version not found"

**Symptom:**
```
Bundle version not found: E:/Bearsampp-development/module-composer/bin/composer2.8.99
```

**Solution:**
1. List available versions: `gradle listVersions`
2. Use an existing version: `gradle release -PbundleVersion=2.8.10`

---

#### Issue: "Java version too old"

**Symptom:**
```
Java 8+ required
```

**Solution:**
1. Check Java version: `java -version`
2. Install Java 8 or higher
3. Update JAVA_HOME environment variable

---

#### Issue: "7-Zip not found"

**Symptom:**
```
7-Zip not found. Please install 7-Zip or set 7Z_HOME environment variable.
```

**Solution:**
1. Install 7-Zip from https://www.7-zip.org/
2. Or set 7Z_HOME environment variable: `set 7Z_HOME=C:\Program Files\7-Zip`
3. Or use zip format instead: Set `bundle.format=zip` in build.properties

---

### Debug Mode

Run Gradle with debug output:

```bash
gradle release -PbundleVersion=2.8.10 --info
gradle release -PbundleVersion=2.8.10 --debug
```

### Clean Build

If you encounter issues, try a clean build:

```bash
gradle clean
gradle release -PbundleVersion=2.8.10
```

---

## Migration Guide

### From Ant to Gradle

The project has been fully migrated from Ant to Gradle. Here's what changed:

#### Removed Files

| File              | Status    | Replacement                |
|-------------------|-----------|----------------------------|
| `build.xml`       | ❌ Removed | `build.gradle`             |

#### Command Mapping

| Ant Command                          | Gradle Command                              |
|--------------------------------------|---------------------------------------------|
| `ant release`                        | `gradle release`                            |
| `ant release -Dinput.bundle=2.8.10`  | `gradle release -PbundleVersion=2.8.10`     |
| `ant clean`                          | `gradle clean`                              |

#### Key Differences

| Aspect              | Ant                          | Gradle                           |
|---------------------|------------------------------|----------------------------------|
| **Build File**      | XML (build.xml)              | Groovy DSL (build.gradle)        |
| **Task Definition** | `<target name="...">`        | `tasks.register('...')`          |
| **Properties**      | `<property name="..." />`    | `ext { ... }`                    |
| **Dependencies**    | Manual downloads             | Automatic with repositories      |
| **Caching**         | None                         | Built-in incremental builds      |
| **IDE Support**     | Limited                      | Excellent (IntelliJ, Eclipse)    |

---

## Additional Resources

- [Gradle Documentation](https://docs.gradle.org/)
- [Bearsampp Project](https://github.com/bearsampp/bearsampp)
- [Composer Website](https://getcomposer.org/)
- [modules-untouched Repository](https://github.com/Bearsampp/modules-untouched)

---

## Support

For issues and questions:

- **GitHub Issues**: https://github.com/bearsampp/module-composer/issues
- **Bearsampp Issues**: https://github.com/bearsampp/bearsampp/issues
- **Documentation**: https://bearsampp.com/module/composer

---

**Last Updated**: 2025-01-31  
**Version**: 2025.8.15  
**Build System**: Pure Gradle (no wrapper, no Ant)

Notes:
- This project deliberately does not ship the Gradle Wrapper. Install Gradle 8+ locally and run with `gradle ...`.
- Legacy Ant files (e.g., Eclipse `.launch` referencing `build.xml`) are deprecated and not used by the build.
