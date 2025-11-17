# Configuration Guide

Complete guide to configuring the Bearsampp Composer Gradle build system.

## Configuration Files

| File                  | Purpose                                  | Required |
|-----------------------|------------------------------------------|----------|
| build.properties      | Bundle configuration                     | Yes      |
| gradle.properties     | Gradle daemon and JVM settings           | No       |
| settings.gradle       | Gradle project settings                  | Yes      |

## build.properties

Main configuration file for the bundle build.

### Location
```
module-composer/build.properties
```

### Required Properties

| Property       | Description                              | Example      |
|----------------|------------------------------------------|--------------|
| bundle.name    | Name of the bundle                       | composer     |
| bundle.release | Release version of the bundle            | 2025.8.15    |
| bundle.type    | Type of bundle (bins/tools/apps)         | tools        |
| bundle.format  | Archive format (7z or zip)               | 7z           |

### Optional Properties

| Property   | Description                              | Example              |
|------------|------------------------------------------|----------------------|
| build.path | Custom build output path                 | C:/Bearsampp-build   |

### Example Configuration

```properties
# Bundle identification
bundle.name = composer
bundle.release = 2025.8.15

# Bundle type and format
bundle.type = tools
bundle.format = 7z

# Optional: Custom build path
#build.path = C:/Bearsampp-build
```

### Property Details

#### bundle.name
- **Type:** String
- **Required:** Yes
- **Description:** Identifies the module name
- **Valid Values:** `composer`
- **Used For:** Archive naming, directory structure

#### bundle.release
- **Type:** Version string (YYYY.M.DD format)
- **Required:** Yes
- **Description:** Release version of the bundle package
- **Example:** `2025.8.15`
- **Used For:** Archive naming, output directory structure

#### bundle.type
- **Type:** String
- **Required:** Yes
- **Description:** Category of the bundle
- **Valid Values:** 
  - `bins` - Binary server components (Apache, MySQL, etc.)
  - `tools` - Development tools (Composer, Git, etc.)
  - `apps` - Applications (Adminer, phpMyAdmin, etc.)
- **Default:** `tools`
- **Used For:** Output directory structure

#### bundle.format
- **Type:** String
- **Required:** Yes
- **Description:** Archive compression format
- **Valid Values:**
  - `7z` - 7-Zip format (better compression, requires 7-Zip)
  - `zip` - ZIP format (universal, built-in support)
- **Default:** `7z`
- **Used For:** Archive creation

#### build.path
- **Type:** Path string
- **Required:** No
- **Description:** Custom location for build output
- **Default:** `../bearsampp-build` (relative to project root)
- **Example:** `C:/Bearsampp-build`
- **Used For:** Output directory base path

---

## gradle.properties

Gradle-specific configuration for daemon and JVM settings.

### Location
```
module-composer/gradle.properties
```

### Common Properties

| Property                        | Description                              | Default |
|---------------------------------|------------------------------------------|---------|
| org.gradle.daemon               | Enable Gradle daemon                     | true    |
| org.gradle.parallel             | Enable parallel execution                | true    |
| org.gradle.caching              | Enable build cache                       | true    |
| org.gradle.jvmargs              | JVM arguments for Gradle                 | -Xmx2g  |

### Example Configuration

```properties
# Gradle daemon configuration
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true

# JVM settings
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError
```

### Performance Tuning

#### For Large Builds
```properties
org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=1g
```

#### For Limited Memory
```properties
org.gradle.jvmargs=-Xmx1g -XX:MaxMetaspaceSize=256m
```

---

## Composer Version Management

The build system downloads composer.phar files from the modules-untouched repository.

### Version Resolution

The build system uses a two-tier approach:

1. **modules-untouched repository** (primary)
   - URL: `https://raw.githubusercontent.com/Bearsampp/modules-untouched/main/modules/composer.properties`
   - Contains version-to-URL mappings

2. **Standard URL format** (fallback)
   - Format: `https://getcomposer.org/download/{version}/composer.phar`
   - Used when modules-untouched is unavailable

### Adding New Versions

To add a new Composer version:

1. Create version directory in `bin/`:
   ```
   bin/composer2.9.0/
   ```

2. Add configuration files to the directory:
   - `composer.bat`
   - `composer.json`
   - `bearsampp.conf`

3. The build system will automatically download the appropriate composer.phar

### Checking Available Versions

```bash
# List versions in bin/ directory
gradle listVersions

# Check modules-untouched integration
gradle checkModulesUntouched

# List all releases from modules-untouched
gradle listReleases
```

---

## settings.gradle

Gradle project settings and configuration.

### Location
```
module-composer/settings.gradle
```

### Configuration

```groovy
// Project name
rootProject.name = 'module-composer'

// Enable stable configuration cache
enableFeaturePreview('STABLE_CONFIGURATION_CACHE')

// Configure build cache
buildCache {
    local {
        enabled = true
        directory = file("${rootDir}/.gradle/build-cache")
        removeUnusedEntriesAfterDays = 30
    }
}

// Display initialization message
gradle.rootProject {
    println """
    ╔════════════════════════════════════════════════════════════════╗
    ║  Bearsampp Module Composer - Gradle Build                     ║
    ║  Project: ${rootProject.name}                                 ║
    ╚════════════════════════════════════════════════════════════════╝
    """.stripIndent()
}
```

---

## Environment Variables

Override configuration using environment variables.

### Build Path Configuration

| Variable              | Description                              | Priority |
|-----------------------|------------------------------------------|----------|
| BEARSAMPP_BUILD_PATH  | Override build output path               | 2        |

**Priority Order:**
1. `build.path` in build.properties (highest)
2. `BEARSAMPP_BUILD_PATH` environment variable
3. Default: `../bearsampp-build` (lowest)

**Example:**
```bash
# Windows Command Prompt
set BEARSAMPP_BUILD_PATH=C:\Bearsampp-build

# Windows PowerShell
$env:BEARSAMPP_BUILD_PATH="C:\Bearsampp-build"

# Linux/macOS
export BEARSAMPP_BUILD_PATH=/opt/bearsampp-build
```

### 7-Zip Configuration

| Variable | Description                              | Example                    |
|----------|------------------------------------------|----------------------------|
| 7Z_HOME  | Custom 7-Zip installation directory      | C:\Program Files\7-Zip     |

**Example:**
```bash
# Windows Command Prompt
set 7Z_HOME=C:\Program Files\7-Zip

# Windows PowerShell
$env:7Z_HOME="C:\Program Files\7-Zip"
```

---

## Build Path Structure

### Default Structure

```
bearsampp-build/
├── tmp/
│   ├── bundles_build/
│   │   └── tools/
│   │       └── composer/
│   ├── bundles_prep/
│   │   └── tools/
│   │       └── composer/
│   ├── bundles_src/
│   ├── downloads/
│   │   └── composer/
│   └── extract/
│       └── composer/
└── tools/
    └── composer/
        └── 2025.8.15/
            ├── bearsampp-composer-2.8.10-2025.8.15.7z
            ├── bearsampp-composer-2.8.10-2025.8.15.7z.md5
            ├── bearsampp-composer-2.8.10-2025.8.15.7z.sha1
            ├── bearsampp-composer-2.8.10-2025.8.15.7z.sha256
            └── bearsampp-composer-2.8.10-2025.8.15.7z.sha512
```

### Directory Purposes

| Directory                    | Purpose                                  |
|------------------------------|------------------------------------------|
| tmp/bundles_build/           | Temporary build workspace                |
| tmp/bundles_prep/            | Prepared files before archiving          |
| tmp/bundles_src/             | Source file cache                        |
| tmp/downloads/               | Downloaded composer.phar files           |
| tmp/extract/                 | Extracted archives (if needed)           |
| {type}/{name}/{release}/     | Final output archives and hashes         |

---

## Configuration Examples

### Example 1: Development Setup

**build.properties:**
```properties
bundle.name = composer
bundle.release = 2025.8.15
bundle.type = tools
bundle.format = zip
```

**Environment:**
```bash
set BEARSAMPP_BUILD_PATH=C:\Dev\bearsampp-build
```

**Result:**
- Uses ZIP format (faster, no 7-Zip required)
- Outputs to: `C:\Dev\bearsampp-build\tools\composer\2025.8.15\`

### Example 2: Production Setup

**build.properties:**
```properties
bundle.name = composer
bundle.release = 2025.8.15
bundle.type = tools
bundle.format = 7z
build.path = C:\Bearsampp-build
```

**Result:**
- Uses 7z format (better compression)
- Outputs to: `C:\Bearsampp-build\tools\composer\2025.8.15\`

### Example 3: CI/CD Setup

**build.properties:**
```properties
bundle.name = composer
bundle.release = 2025.8.15
bundle.type = tools
bundle.format = 7z
```

**Environment:**
```bash
set BEARSAMPP_BUILD_PATH=%WORKSPACE%\build-output
set 7Z_HOME=C:\Tools\7-Zip
```

**Result:**
- Uses workspace-relative path
- Custom 7-Zip location
- Outputs to: `%WORKSPACE%\build-output\tools\composer\2025.8.15\`

---

## Validation

### Validate Configuration

Check your configuration is correct:

```bash
gradle validateProperties
```

### Verify Environment

Check all requirements are met:

```bash
gradle verify
```

### Display Configuration

View current configuration:

```bash
gradle info
```

---

## Best Practices

### 1. Version Control

**Do commit:**
- `build.properties` (with commented build.path)
- `gradle.properties`
- `releases.properties`
- `settings.gradle`

**Don't commit:**
- `build/` directory
- `bearsampp-build/` directory
- `.gradle/` directory
- Local environment-specific settings

### 2. Build Path

**Recommended:**
- Use environment variable for local development
- Use build.properties for shared/CI environments
- Keep build output outside project directory

### 3. Archive Format

**Use 7z when:**
- Distributing to end users (smaller downloads)
- Storage space is limited
- Build time is not critical

**Use zip when:**
- Quick testing/development
- 7-Zip is not available
- Cross-platform compatibility is needed

### 4. Release Versioning

**Format:** `YYYY.M.DD`
- `YYYY` - Four-digit year
- `M` - Month (1-12, no leading zero)
- `DD` - Day (01-31, with leading zero)

**Examples:**
- `2025.1.15` - January 15, 2025
- `2025.12.01` - December 1, 2025

---

## Troubleshooting

### Configuration Not Loading

**Problem:** Changes to build.properties not taking effect

**Solution:**
1. Clean the build: `gradle clean`
2. Refresh Gradle: `gradle --refresh-dependencies`
3. Check file encoding (should be UTF-8 or ISO-8859-1)

### Build Path Issues

**Problem:** Build outputs to wrong location

**Solution:**
1. Check priority order (build.properties > env var > default)
2. Verify path syntax (use forward slashes or escaped backslashes)
3. Run `gradle info` to see resolved path

### Property Validation Fails

**Problem:** validateProperties task fails

**Solution:**
1. Check all required properties are present
2. Ensure no empty values
3. Verify property names are spelled correctly

---

## Next Steps

- [Task Reference](TASKS.md) - Learn about available tasks
- [Examples](EXAMPLES.md) - See configuration in action
- [Troubleshooting](TROUBLESHOOTING.md) - Solve common problems
