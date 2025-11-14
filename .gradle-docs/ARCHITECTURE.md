# Build System Architecture

Technical documentation of the Bearsampp Composer Gradle build system architecture, design decisions, and implementation details.

## Overview

The build system is a pure Gradle implementation that packages Composer PHP dependency manager for the Bearsampp development environment. It replaces the previous Ant-based build system with a modern, maintainable solution.

## Design Principles

| Principle              | Description                                              |
|------------------------|----------------------------------------------------------|
| Pure Gradle            | No Ant dependencies, uses only Gradle features           |
| Convention over Config | Sensible defaults, minimal required configuration        |
| Flexibility            | Multiple configuration methods, extensible design        |
| Reproducibility        | Consistent builds across environments                    |
| Transparency           | Clear logging, detailed output, comprehensive validation |

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     User Interface                          │
│  (Gradle CLI, IDE Integration, CI/CD)                       │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│                  Gradle Build Script                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Tasks      │  │   Helpers    │  │   Config     │      │
│  │              │  │              │  │              │      │
│  │ • release    │  │ • download   │  │ • Properties │      │
│  │ • releaseAll │  │ • extract    │  │ • Paths      │      │
│  │ • verify     │  │ • compress   │  │ • Versions   │      │
│  │ • clean      │  │ • hash       │  │              │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│                  File System                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Source     │  │   Temp       │  │   Output     │      │
│  │              │  │              │  │              │      │
│  │ • bin/       │  │ • downloads/ │  │ • archives/  │      │
│  │ • config/    │  │ • prep/      │  │ • hashes/    │      │
│  └───────���──────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### Component Architecture

```
build.gradle
├── Plugins
│   └── base (Gradle core plugin)
├── Configuration
│   ├── Properties Loading
│   ├── Path Resolution
│   └── Extension Properties
├── Helper Functions
│   ├── downloadComposerPhar()
│   ├── downloadComposerDirect()
│   ├── downloadAndExtractComposer()
│   ├── find7ZipExecutable()
│   ├── getAvailableVersions()
│   ├── generateHashFiles()
│   └── calculateHash()
└── Tasks
    ├── Build Tasks
    │   ├── release
    │   ├── releaseAll
    │   ├── clean
    │   └── downloadComposer
    ├── Help Tasks
    │   ├── info
    │   ├── listVersions
    │   └── listReleases
    └── Verification Tasks
        ├── verify
        └── validateProperties
```

## Core Components

### 1. Configuration System

#### Property Loading

```groovy
def buildProps = new Properties()
file('build.properties').withInputStream { buildProps.load(it) }
```

**Purpose:** Load bundle configuration from properties file

**Properties:**
- `bundle.name` - Module identifier
- `bundle.release` - Release version
- `bundle.type` - Bundle category
- `bundle.format` - Archive format
- `build.path` - Optional custom build path

#### Path Resolution

```groovy
ext {
    // Priority: 1) build.properties, 2) Environment, 3) Default
    def buildPathFromProps = buildProps.getProperty('build.path', '').trim()
    def buildPathFromEnv = System.getenv('BEARSAMPP_BUILD_PATH') ?: ''
    def defaultBuildPath = "${rootDir}/bearsampp-build"
    
    buildBasePath = buildPathFromProps ?: (buildPathFromEnv ?: defaultBuildPath)
}
```

**Purpose:** Resolve build output path with priority system

**Priority Order:**
1. `build.path` in build.properties (highest)
2. `BEARSAMPP_BUILD_PATH` environment variable
3. Default: `../bearsampp-build` (lowest)

#### Extension Properties

```groovy
ext {
    projectBasedir = projectDir.absolutePath
    rootDir = projectDir.parent
    devPath = file("${rootDir}/dev").absolutePath
    bundleName = buildProps.getProperty('bundle.name', 'composer')
    bundleRelease = buildProps.getProperty('bundle.release', '1.0.0')
    // ... more properties
}
```

**Purpose:** Define project-wide variables accessible to all tasks

### 2. Helper Functions

#### downloadComposerPhar()

```groovy
def downloadComposerPhar(String version) {
    // 1. Load untouched URLs from modules-untouched repository
    // 2. Find URL for specified version
    // 3. Download composer.phar
    // 4. Cache in downloads directory
    // 5. Return File object
}
```

**Purpose:** Download Composer PHAR from modules-untouched repository

**Flow:**
```
Input: version (e.g., "2.8.10")
  ↓
Load modules-untouched/composer.properties
  ↓
Find URL for version
  ↓
Download to cache (if not exists)
  ↓
Output: File object
```

#### find7ZipExecutable()

```groovy
def find7ZipExecutable() {
    // 1. Check 7Z_HOME environment variable
    // 2. Check common installation paths
    // 3. Check PATH environment
    // 4. Return path or null
}
```

**Purpose:** Locate 7-Zip executable for archive creation

**Search Order:**
1. `7Z_HOME` environment variable
2. Common paths (C:\Program Files\7-Zip\, etc.)
3. System PATH

#### getAvailableVersions()

```groovy
def getAvailableVersions() {
    // 1. Scan bin/ directory
    // 2. Scan bin/archived/ directory
    // 3. Extract version numbers
    // 4. Remove duplicates
    // 5. Sort and return
}
```

**Purpose:** Discover available Composer versions

**Output:** List of version strings (e.g., ["2.8.10", "2.8.9", ...])

#### generateHashFiles()

```groovy
def generateHashFiles(File file) {
    // For each algorithm (MD5, SHA1, SHA256, SHA512):
    //   1. Calculate hash
    //   2. Write to {file}.{algorithm} file
}
```

**Purpose:** Generate cryptographic hash files for verification

**Algorithms:**
- MD5
- SHA-1
- SHA-256
- SHA-512

### 3. Task System

#### Task Registration

```groovy
tasks.register('taskName') {
    group = 'groupName'
    description = 'Task description'
    
    doLast {
        // Task implementation
    }
}
```

**Purpose:** Define executable build tasks

**Task Groups:**
- `build` - Build and package tasks
- `help` - Information and listing tasks
- `verification` - Validation tasks

#### Task Lifecycle

```
Configuration Phase
  ↓
Task Graph Construction
  ↓
Execution Phase
  ↓
Task Execution
  ↓
Cleanup
```

## Build Process Flow

### Release Build Flow

```
gradle release -PbundleVersion=2.8.10
  ↓
┌─────────────────────────────────────┐
│ 1. Validate Version                 │
│    • Check bin/ directory           │
│    • Check bin/archived/ directory  │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│ 2. Download Composer PHAR           │
│    • Load modules-untouched URLs    │
│    • Download composer.phar         │
│    • Cache in downloads/            │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│ 3. Prepare Files                    │
│    • Create prep directory          │
│    • Copy composer.phar             │
│    • Copy config files from bin/    │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│ 4. Create Archive                   │
│    • Determine format (7z/zip)      │
│    • Compress files                 │
│    • Output to build directory      │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│ 5. Generate Hashes                  │
│    • Calculate MD5                  │
│    • Calculate SHA1                 │
│    • Calculate SHA256               │
│    • Calculate SHA512               │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│ 6. Output Results                   │
│    • Display summary                │
│    • Show output location           │
└─────────────────────────────────────┘
```

### Release All Flow

```
gradle releaseAll
  ↓
┌─────────────────────────────────────┐
│ 1. Discover Versions                │
│    • Scan bin/                      │
│    • Scan bin/archived/             │
│    • Build version list             │
└────────��───┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│ 2. Iterate Versions                 │
│    For each version:                │
│      • Execute release build        │
│      • Track success/failure        │
│      • Continue on error            │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│ 3. Generate Summary                 │
│    • Count successes                │
│    • List failures                  │
│    • Display report                 │
└─────────────────────────────────────┘
```

## Directory Structure

### Source Structure

```
module-composer/
├── bin/                          # Version directories
│   ├── composer2.8.10/           # Version-specific files
│   │   ├── composer.bat          # Windows launcher
│   │   ├── composer.json         # Composer config
│   │   └── bearsampp.conf        # Bearsampp config
│   └── archived/                 # Archived versions
│       └── composer2.8.8/
├── build.gradle                  # Build script
├── build.properties              # Bundle config
├── gradle.properties             # Gradle config
├── releases.properties           # Version URLs
└── settings.gradle               # Project settings
```

### Build Structure

```
bearsampp-build/
├── tmp/                          # Temporary files
│   ├── bundles_build/            # Build workspace
│   ├── bundles_prep/             # Prepared files
│   │   └── tools/
│   │       └── composer/
│   │           └── composer2.8.10/
│   │               ├── composer.phar
│   │               ├── composer.bat
│   │               ├── composer.json
│   │               └── bearsampp.conf
│   ├── bundles_src/              # Source cache
│   ├── downloads/                # Downloaded files
│   │   └── composer/
│   │       └── composer-2.8.10.phar
│   └── extract/                  # Extracted archives
└── tools/                        # Output directory
    └── composer/
        └── 2025.8.15/            # Release version
            ├── bearsampp-composer-2.8.10-2025.8.15.7z
            ├── bearsampp-composer-2.8.10-2025.8.15.7z.md5
            ├── bearsampp-composer-2.8.10-2025.8.15.7z.sha1
            ├── bearsampp-composer-2.8.10-2025.8.15.7z.sha256
            └── bearsampp-composer-2.8.10-2025.8.15.7z.sha512
```

## Data Flow

### Configuration Data Flow

```
build.properties
  ↓
Properties Object
  ↓
Extension Properties
  ↓
Tasks
```

### Version Data Flow

```
bin/ directory
  ↓
getAvailableVersions()
  ↓
Version List
  ↓
User Selection / Parameter
  ↓
Release Task
```

### File Data Flow

```
modules-untouched repository
  ↓
Download (composer.phar)
  ↓
Cache (downloads/)
  ↓
Prepare (bundles_prep/)
  ↓
Archive (tools/composer/release/)
```

## Design Decisions

### 1. Pure Gradle Implementation

**Decision:** Use only Gradle, no Ant dependencies

**Rationale:**
- Modern build system
- Better IDE integration
- Improved maintainability
- Consistent with other modules

**Trade-offs:**
- Required rewriting Ant logic
- Learning curve for Ant users

### 2. Three-Level Configuration Priority

**Decision:** build.properties > environment > default

**Rationale:**
- Flexibility for different environments
- Override capability without file changes
- Sensible defaults for quick start

**Trade-offs:**
- More complex resolution logic
- Potential confusion about which value is used

### 3. Separate bin/ and bin/archived/

**Decision:** Support both current and archived versions

**Rationale:**
- Organize versions by status
- Keep active versions easily accessible
- Maintain historical versions

**Trade-offs:**
- More complex version discovery
- Potential for duplicates

### 4. Hash File Generation

**Decision:** Generate MD5, SHA1, SHA256, SHA512

**Rationale:**
- Security verification
- Integrity checking
- Multiple algorithm support

**Trade-offs:**
- Increased build time
- More output files

### 5. Interactive Mode

**Decision:** Support both interactive and non-interactive modes

**Rationale:**
- User-friendly for manual builds
- Scriptable for automation
- Flexible for different use cases

**Trade-offs:**
- More complex task logic
- Input handling complexity

## Extension Points

### Adding New Tasks

```groovy
tasks.register('customTask') {
    group = 'custom'
    description = 'Custom task description'
    
    doLast {
        // Task implementation
    }
}
```

### Adding New Helper Functions

```groovy
def customHelper(String param) {
    // Helper implementation
    return result
}
```

### Adding New Configuration

```groovy
ext {
    customProperty = buildProps.getProperty('custom.property', 'default')
}
```

## Performance Considerations

### Caching Strategy

| Cache Type        | Location                  | Purpose                      |
|-------------------|---------------------------|------------------------------|
| Download Cache    | tmp/downloads/            | Avoid re-downloading files   |
| Build Cache       | .gradle/build-cache/      | Gradle task output cache     |
| Configuration Cache| .gradle/configuration-cache/| Gradle configuration cache |

### Optimization Techniques

1. **Parallel Execution**
   - Enabled via `org.gradle.parallel=true`
   - Multiple versions can build in parallel

2. **Incremental Builds**
   - Gradle tracks task inputs/outputs
   - Skips up-to-date tasks

3. **Download Caching**
   - Downloaded files cached locally
   - Reused across builds

4. **Configuration Cache**
   - Gradle configuration cached
   - Faster subsequent builds

## Security Considerations

### Hash Verification

- Multiple hash algorithms for redundancy
- Allows users to verify download integrity
- Supports different security requirements

### Download Sources

- Uses official modules-untouched repository
- HTTPS for secure downloads
- Verifiable source URLs

### File Permissions

- Respects system file permissions
- No elevation required
- Safe for user-level execution

## Testing Strategy

### Manual Testing

```bash
# Test environment
gradle verify

# Test version listing
gradle listVersions

# Test single build
gradle release -PbundleVersion=2.8.10

# Test batch build
gradle releaseAll

# Test cleanup
gradle clean
```

### Validation Points

1. **Configuration Validation**
   - `validateProperties` task
   - Property presence and format

2. **Environment Validation**
   - `verify` task
   - Prerequisites check

3. **Build Validation**
   - Archive creation
   - Hash generation
   - Output structure

## Maintenance

### Adding New Versions

1. Add entry to `releases.properties`
2. Create directory in `bin/`
3. Add configuration files
4. Test with `gradle release`

### Updating Configuration

1. Modify `build.properties`
2. Run `gradle validateProperties`
3. Run `gradle verify`
4. Test build

### Troubleshooting

1. Check logs for errors
2. Run `gradle info` for configuration
3. Run `gradle verify` for environment
4. See [Troubleshooting Guide](TROUBLESHOOTING.md)

## Future Enhancements

### Potential Improvements

| Enhancement                  | Benefit                                  |
|------------------------------|------------------------------------------|
| Parallel version builds      | Faster releaseAll execution              |
| Checksum verification        | Validate downloaded files                |
| Version auto-discovery       | Automatic releases.properties update     |
| Docker support               | Containerized builds                     |
| Cloud storage integration    | Direct upload to distribution servers    |

---

## Next Steps

- [Configuration Guide](CONFIG.md) - Configure the build system
- [Task Reference](TASKS.md) - Learn about available tasks
- [Examples](EXAMPLES.md) - See real-world usage
