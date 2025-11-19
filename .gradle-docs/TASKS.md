# Gradle Tasks Reference

Complete reference for all Gradle tasks available in the Bearsampp Composer module build system.

## Task Groups

| Group        | Description                                    |
|--------------|------------------------------------------------|
| build        | Build and package tasks                        |
| help         | Help and information tasks                     |
| verification | Verification and validation tasks              |

## Build Tasks

### release

Build a release package for a specific Composer version.

**Usage:**
```bash
# Non-interactive mode (recommended for CI/CD)
gradle release -PbundleVersion=2.8.10

# Interactive mode (prompts for version selection)
gradle release
```

**Parameters:**
| Parameter       | Required | Description                              |
|-----------------|----------|------------------------------------------|
| bundleVersion   | No*      | Composer version to build (e.g., 2.8.10) |

*Required for non-interactive mode

**What It Does:**
1. Validates the specified version exists in `bin/` or `bin/archived/`
2. Downloads composer.phar from modules-untouched repository
3. Copies configuration files from the version directory
4. Creates compressed archive (7z or zip based on configuration)
5. Generates hash files (MD5, SHA1, SHA256, SHA512)
6. Outputs to: `bearsampp-build/tools/composer/{release}/`

**Example Output:**
```
======================================================================
Building release for composer version 2.8.10...
======================================================================
Bundle path: E:\Bearsampp-development\module-composer\bin\composer2.8.10

Downloading composer.phar for version 2.8.10...
  Loading untouched URLs from: https://raw.githubusercontent.com/...
  PHAR URL: https://getcomposer.org/download/2.8.10/composer.phar
  Using cached file: bearsampp-build/tmp/downloads/composer/composer-2.8.10.phar
  Composer PHAR 2.8.10 ready

Copying Composer files...

Preparing archive...
Compressing composer2.8.10 to bearsampp-composer-2.8.10-2025.8.15.7z...
Using 7-Zip: C:\Program Files\7-Zip\7z.exe
Archive created: bearsampp-build/tools/composer/2025.8.15/bearsampp-composer-2.8.10-2025.8.15.7z

Generating hash files...
  Created: bearsampp-composer-2.8.10-2025.8.15.7z.md5
  Created: bearsampp-composer-2.8.10-2025.8.15.7z.sha1
  Created: bearsampp-composer-2.8.10-2025.8.15.7z.sha256
  Created: bearsampp-composer-2.8.10-2025.8.15.7z.sha512

======================================================================
[SUCCESS] Release build completed successfully for version 2.8.10
Output directory: bearsampp-build/tools/composer/2025.8.15
Archive: bearsampp-composer-2.8.10-2025.8.15.7z
======================================================================
```

---

### releaseAll

Build release packages for all available Composer versions.

**Usage:**
```bash
gradle releaseAll
```

**Parameters:** None

**What It Does:**
1. Scans `bin/` and `bin/archived/` for all available versions
2. Builds each version sequentially
3. Provides progress updates and summary
4. Lists any failed builds

**Example Output:**
```
======================================================================
Building releases for 21 composer versions
======================================================================

======================================================================
[1/21] Building composer 2.8.10...
======================================================================
Bundle path: E:\Bearsampp-development\module-composer\bin\composer2.8.10
...
[SUCCESS] composer 2.8.10 completed

======================================================================
[2/21] Building composer 2.8.9...
======================================================================
...

======================================================================
Build Summary
======================================================================
Total versions: 21
Successful:     21
Failed:         0
======================================================================
[SUCCESS] All versions built successfully!
```

---

### clean

Clean build artifacts and temporary files.

**Usage:**
```bash
gradle clean
```

**Parameters:** None

**What It Does:**
1. Removes the `build/` directory
2. Cleans Gradle cache files

**Example Output:**
```
[SUCCESS] Build artifacts cleaned
```

**Note:** This does NOT clean the `bearsampp-build/` output directory. To clean that, manually delete it or use:
```bash
Remove-Item -Recurse -Force bearsampp-build
```

---

### downloadComposer

Download a specific Composer PHAR file directly.

**Usage:**
```bash
gradle downloadComposer -PcomposerVersion=2.8.10
```

**Parameters:**
| Parameter        | Required | Description                              |
|------------------|----------|------------------------------------------|
| composerVersion  | Yes      | Composer version to download (e.g., 2.8.10) |

**What It Does:**
1. Downloads composer.phar from modules-untouched repository
2. Caches the file in `bearsampp-build/tmp/downloads/composer/`
3. Displays the download location

**Example Output:**
```
Downloading Composer 2.8.10...
  Loading untouched URLs from: https://raw.githubusercontent.com/...
  PHAR URL: https://getcomposer.org/download/2.8.10/composer.phar
  Downloading to: bearsampp-build/tmp/downloads/composer/composer-2.8.10.phar
  Download complete
  Composer PHAR 2.8.10 ready
[SUCCESS] Downloaded to: bearsampp-build/tmp/downloads/composer/composer-2.8.10.phar
```

---

## Help Tasks

### info

Display comprehensive build configuration information.

**Usage:**
```bash
gradle info
```

**Parameters:** None

**What It Does:**
Displays detailed information about:
- Project configuration
- Bundle properties
- File paths
- Java environment
- Gradle environment
- Available task groups
- Quick start commands

**Example Output:**
```
================================================================
          Bearsampp Module Composer - Build Info
================================================================

Project:        module-composer
Version:        2025.8.15
Description:    Bearsampp Module - composer

Bundle Properties:
  Name:         composer
  Release:      2025.8.15
  Type:         tools
  Format:       7z

Paths:
  Project Dir:  E:\Bearsampp-development\module-composer
  Root Dir:     E:\Bearsampp-development
  Dev Path:     E:\Bearsampp-development\dev
  Build Base:   E:\Bearsampp-development\bearsampp-build
  Build Tmp:    E:\Bearsampp-development\bearsampp-build\tmp
  Tmp Prep:     E:\Bearsampp-development\bearsampp-build\tmp\bundles_prep\tools\composer
  Tmp Build:    E:\Bearsampp-development\bearsampp-build\tmp\bundles_build\tools\composer
  Tmp Src:      E:\Bearsampp-development\bearsampp-build\tmp\bundles_src
  Tmp Download: E:\Bearsampp-development\bearsampp-build\tmp\downloads\composer
  Tmp Extract:  E:\Bearsampp-development\bearsampp-build\tmp\extract\composer

Java:
  Version:      17.0.2
  Home:         C:\Program Files\Java\jdk-17.0.2

Gradle:
  Version:      8.5
  Home:         C:\Users\user\.gradle\wrapper\dists\gradle-8.5-bin\...

Available Task Groups:
  * build        - Build and package tasks
  * help         - Help and information tasks
  * verification - Verification tasks

Quick Start:
  gradle tasks                            - List all available tasks
  gradle info                             - Show this information
  gradle listVersions                     - List available versions
  gradle release -PbundleVersion=2.8.10   - Build release for version
  gradle releaseAll                       - Build all available versions
  gradle clean                            - Clean build artifacts
  gradle verify                           - Verify build environment
```

---

### listVersions

List all available Composer versions in the bin/ directory.

**Usage:**
```bash
gradle listVersions
```

**Parameters:** None

**What It Does:**
1. Scans `bin/` directory for version folders
2. Scans `bin/archived/` directory for archived versions
3. Displays versions with location tags
4. Shows total count

**Example Output:**
```
Available composer versions:
------------------------------------------------------------
  2.8.10          [bin]
  2.8.9           [bin]
  2.8.8           [bin/archived]
  2.8.7           [bin/archived]
  2.8.6           [bin/archived]
  ...
------------------------------------------------------------
Total versions: 21

To build a specific version:
  gradle release -PbundleVersion=2.8.10
```

---

### listReleases

List all available releases from releases.properties file.

**Usage:**
```bash
gradle listReleases
```

**Parameters:** None

**What It Does:**
1. Reads `releases.properties` file
2. Displays all version-to-URL mappings
3. Shows total count

**Example Output:**
```
Available Composer Releases:
--------------------------------------------------------------------------------
  2.8.10     -> https://getcomposer.org/download/2.8.10/composer.phar
  2.8.9      -> https://getcomposer.org/download/2.8.9/composer.phar
  2.8.8      -> https://getcomposer.org/download/2.8.8/composer.phar
  ...
--------------------------------------------------------------------------------
Total releases: 21
```

---

### tasks

List all available Gradle tasks (built-in Gradle task).

**Usage:**
```bash
gradle tasks
```

**Parameters:** None

**What It Does:**
Displays all tasks organized by group with descriptions.

**Example Output:**
```
Build tasks
-----------
clean - Clean build artifacts and temporary files
downloadComposer - Download Composer PHAR file (use -PcomposerVersion=X.X.X)
release - Build release package (use -PbundleVersion=X.X.X to specify version)
releaseAll - Build release packages for all available versions in bin/ directory

Help tasks
----------
info - Display build configuration information
listReleases - List all available releases from releases.properties
listVersions - List all available bundle versions in bin/ and bin/archived/ directories

Verification tasks
------------------
validateProperties - Validate build.properties configuration
verify - Verify build environment and dependencies
```

---

## Verification Tasks

### verify

Verify the build environment and dependencies.

**Usage:**
```bash
gradle verify
```

**Parameters:** None

**What It Does:**
Checks the following requirements:
- Java version (8 or higher)
- build.properties file exists
- releases.properties file exists
- dev directory exists
- bin directory exists
- 7-Zip is available (if format is 7z)

**Example Output:**
```
Verifying build environment for module-composer...

Environment Check Results:
------------------------------------------------------------
  [PASS]     Java 8+
  [PASS]     build.properties
  [PASS]     releases.properties
  [PASS]     dev directory
  [PASS]     bin directory
  [PASS]     7-Zip
------------------------------------------------------------

[SUCCESS] All checks passed! Build environment is ready.

You can now run:
  gradle release -PbundleVersion=2.8.10   - Build release for version
  gradle listVersions                     - List available versions
```

**Failure Example:**
```
Environment Check Results:
------------------------------------------------------------
  [PASS]     Java 8+
  [PASS]     build.properties
  [PASS]     releases.properties
  [PASS]     dev directory
  [PASS]     bin directory
  [FAIL]     7-Zip
------------------------------------------------------------

[WARNING] Some checks failed. Please review the requirements.

FAILURE: Build failed with an exception.
* What went wrong:
Execution failed for task ':verify'.
> Build environment verification failed
```

---

### validateProperties

Validate the build.properties configuration file.

**Usage:**
```bash
gradle validateProperties
```

**Parameters:** None

**What It Does:**
1. Checks that all required properties are present
2. Validates property values are not empty
3. Displays current property values

**Required Properties:**
- `bundle.name`
- `bundle.release`
- `bundle.type`
- `bundle.format`

**Example Output:**
```
Validating build.properties...
[SUCCESS] All required properties are present:
    bundle.name = composer
    bundle.release = 2025.8.15
    bundle.type = tools
    bundle.format = 7z
```

**Failure Example:**
```
Validating build.properties...
[ERROR] Missing required properties:
    - bundle.release
    - bundle.format

FAILURE: Build failed with an exception.
* What went wrong:
Execution failed for task ':validateProperties'.
> build.properties validation failed
```

---

## Task Dependencies

Some tasks depend on others:

```
verify
  └── (checks environment)

release
  └── (validates version exists)
      └── (downloads composer.phar)
          └── (creates archive)
              └── (generates hashes)

releaseAll
  └── (calls release for each version)

validateProperties
  └── (checks build.properties)
```

## Task Execution Order

When running multiple tasks:

```bash
gradle verify release -PbundleVersion=2.8.10
```

Tasks execute in the order specified:
1. `verify` - Check environment
2. `release` - Build release

## Common Task Combinations

| Command                                      | Use Case                                 |
|----------------------------------------------|------------------------------------------|
| `gradle verify release -PbundleVersion=X.X.X`| Verify then build                        |
| `gradle clean release -PbundleVersion=X.X.X` | Clean then build                         |
| `gradle listVersions release`                | List versions then build interactively   |
| `gradle info verify`                         | Show config and verify environment       |

---

## Next Steps

- [Configuration Guide](CONFIG.md) - Learn about configuration options
- [Examples](EXAMPLES.md) - See real-world usage examples
- [Troubleshooting](TROUBLESHOOTING.md) - Solve common problems
