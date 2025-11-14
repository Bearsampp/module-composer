# Migration Guide: Ant to Gradle

Complete guide for migrating from the Ant-based build system to the new Gradle-based build system.

## Overview

This guide helps you transition from the legacy Ant build system to the modern Gradle build system for the Bearsampp Composer module.

## Migration Summary

| Aspect              | Ant Build                    | Gradle Build                 |
|---------------------|------------------------------|------------------------------|
| Build File          | build.xml                    | build.gradle                 |
| Configuration       | build.properties             | build.properties (same)      |
| Task Execution      | `ant release.build`          | `gradle release`             |
| Dependencies        | External (dev/build/)        | Self-contained               |
| Version Selection   | Manual editing               | Interactive or parameter     |
| Output Location     | Fixed                        | Configurable (3 levels)      |
| Hash Generation     | Manual/separate              | Automatic                    |
| Verification        | Manual                       | Built-in tasks               |

## Prerequisites

Before migrating, ensure you have:

| Requirement      | Version     | Check Command              |
|------------------|-------------|----------------------------|
| Java             | 8 or higher | `java -version`            |
| Gradle           | 7.0+        | `gradle --version`         |
| 7-Zip (optional) | Any version | Check Program Files        |

## Migration Steps

### Step 1: Backup Current Setup

Create a backup of your current Ant-based setup:

```bash
# Create backup directory
mkdir backup-ant

# Copy Ant build files
copy build.xml backup-ant\
copy build.properties backup-ant\

# Optional: Backup any custom scripts
copy *.bat backup-ant\
```

### Step 2: Verify Gradle Installation

Check that Gradle is properly installed:

```bash
gradle --version
```

**Expected Output:**
```
------------------------------------------------------------
Gradle 8.5
------------------------------------------------------------

Build time:   2023-11-29 14:08:57 UTC
Revision:     28aca86a7180baa17117e0e5ba01d8ea9feca598

Kotlin:       1.9.20
Groovy:       3.0.17
Ant:          Apache Ant(TM) version 1.10.13 compiled on January 4 2023
JVM:          17.0.2 (Oracle Corporation 17.0.2+8-86)
OS:           Windows 10 10.0 amd64
```

### Step 3: Understand Configuration Changes

#### build.properties (No Changes Required)

The `build.properties` file format remains the same:

```properties
# Ant version (old)
bundle.name = composer
bundle.release = 2025.8.15
bundle.type = tools
bundle.format = 7z

# Gradle version (same)
bundle.name = composer
bundle.release = 2025.8.15
bundle.type = tools
bundle.format = 7z
```

**No migration needed for this file.**

#### New Configuration Options

Gradle adds optional configuration:

```properties
# Optional: Custom build path
build.path = C:/Bearsampp-build
```

Or use environment variable:

```bash
set BEARSAMPP_BUILD_PATH=C:\Bearsampp-build
```

### Step 4: Update Build Commands

#### Command Mapping

| Ant Command                  | Gradle Equivalent                        | Notes                        |
|------------------------------|------------------------------------------|------------------------------|
| `ant release.build`          | `gradle release -PbundleVersion=X.X.X`   | Version now a parameter      |
| `ant clean`                  | `gradle clean`                           | Same command                 |
| N/A                          | `gradle verify`                          | New: Environment check       |
| N/A                          | `gradle listVersions`                    | New: List available versions |
| N/A                          | `gradle info`                            | New: Show configuration      |

#### Example Migration

**Old Ant Workflow:**
```bash
# Edit build.xml to set version
notepad build.xml

# Run build
ant release.build

# Manually verify output
dir ..\bearsampp-build\
```

**New Gradle Workflow:**
```bash
# List available versions
gradle listVersions

# Build specific version
gradle release -PbundleVersion=2.8.10

# Verify automatically
gradle verify
```

### Step 5: Verify Migration

Run the verification task to ensure everything is set up correctly:

```bash
gradle verify
```

**Expected Output:**
```
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
```

### Step 6: Test Build

Perform a test build to ensure everything works:

```bash
# List available versions
gradle listVersions

# Build a test version
gradle release -PbundleVersion=2.8.10

# Verify output
dir bearsampp-build\tools\composer\2025.8.15\
```

### Step 7: Remove Ant Files (Optional)

Once you've verified Gradle builds work correctly, you can remove Ant files:

```bash
# Remove Ant build file
del build.xml

# Keep build.properties (used by both)
# Keep releases.properties (used by both)
```

**Note:** The migration task will handle this automatically.

## Feature Comparison

### Features Available in Both

| Feature                  | Ant | Gradle | Notes                        |
|--------------------------|-----|--------|------------------------------|
| Build release package    | ✓   | ✓      | Same functionality           |
| Use build.properties     | ✓   | ✓      | Same file format             |
| Create archives          | ✓   | ✓      | 7z and zip support           |
| Version management       | ✓   | ✓      | Gradle adds auto-discovery   |

### New Features in Gradle

| Feature                  | Description                              |
|--------------------------|------------------------------------------|
| Interactive mode         | Select version from menu                 |
| Environment verification | Check prerequisites before building      |
| Property validation      | Validate configuration                   |
| Automatic hash generation| MD5, SHA1, SHA256, SHA512                |
| Version listing          | List all available versions              |
| Batch building           | Build all versions at once               |
| Configurable build path  | Three-level priority system              |
| Better error messages    | Clear, actionable error messages         |
| Progress tracking        | Real-time build progress                 |

### Features Removed

| Feature                  | Reason                                   |
|--------------------------|------------------------------------------|
| Ant task imports         | No longer needed (pure Gradle)           |
| External build scripts   | Self-contained in build.gradle           |

## Configuration Migration

### Build Path Configuration

**Ant (Fixed):**
```xml
<property name="build.path" location="${root.dir}/bearsampp-build"/>
```

**Gradle (Flexible):**
```properties
# Option 1: In build.properties
build.path = C:/Bearsampp-build

# Option 2: Environment variable
set BEARSAMPP_BUILD_PATH=C:\Bearsampp-build

# Option 3: Default (no configuration needed)
# Uses: ../bearsampp-build
```

### Version Selection

**Ant (Manual):**
```xml
<!-- Edit build.xml -->
<property name="bundle.version" value="2.8.10"/>
```

**Gradle (Parameter):**
```bash
# Command line parameter
gradle release -PbundleVersion=2.8.10

# Or interactive mode
gradle release
# (prompts for version)
```

## Script Migration

### Batch Scripts

If you have batch scripts that call Ant, update them for Gradle:

**Old (Ant):**
```batch
@echo off
echo Building Composer module...
ant release.build
if errorlevel 1 (
    echo Build failed!
    exit /b 1
)
echo Build successful!
```

**New (Gradle):**
```batch
@echo off
echo Building Composer module...
gradle release -PbundleVersion=2.8.10
if errorlevel 1 (
    echo Build failed!
    exit /b 1
)
echo Build successful!
```

### CI/CD Integration

**Old (Ant):**
```yaml
# .github/workflows/build.yml
- name: Build with Ant
  run: ant release.build
```

**New (Gradle):**
```yaml
# .github/workflows/build.yml
- name: Build with Gradle
  run: gradle release -PbundleVersion=${{ env.VERSION }}
```

## Troubleshooting Migration

### Common Issues

#### Issue 1: Gradle Not Found

**Error:**
```
'gradle' is not recognized as an internal or external command
```

**Solution:**
1. Install Gradle from [gradle.org](https://gradle.org/install/)
2. Or use the Gradle Wrapper (if available):
   ```bash
   gradlew release -PbundleVersion=2.8.10
   ```

#### Issue 2: Java Version Too Old

**Error:**
```
Gradle requires Java 8 or higher
```

**Solution:**
1. Install Java 8 or higher
2. Set JAVA_HOME environment variable
3. Verify: `java -version`

#### Issue 3: Build Path Not Found

**Error:**
```
Build path not found: C:\Bearsampp-build
```

**Solution:**
1. Check build.properties for correct path
2. Or use environment variable:
   ```bash
   set BEARSAMPP_BUILD_PATH=C:\Bearsampp-build
   ```
3. Or let Gradle use default path

#### Issue 4: 7-Zip Not Found

**Error:**
```
7-Zip not found. Please install 7-Zip or set 7Z_HOME environment variable.
```

**Solution:**
1. Install 7-Zip from [7-zip.org](https://www.7-zip.org/)
2. Or set 7Z_HOME:
   ```bash
   set 7Z_HOME=C:\Program Files\7-Zip
   ```
3. Or change format to zip in build.properties:
   ```properties
   bundle.format = zip
   ```

#### Issue 5: Version Not Found

**Error:**
```
Bundle version not found: composer2.8.10
```

**Solution:**
1. List available versions:
   ```bash
   gradle listVersions
   ```
2. Use a version from the list
3. Or check bin/ directory structure

### Getting Help

If you encounter issues during migration:

1. **Check Documentation:**
   - [Quick Start Guide](QUICK_START.md)
   - [Troubleshooting Guide](TROUBLESHOOTING.md)
   - [Configuration Guide](CONFIG.md)

2. **Verify Environment:**
   ```bash
   gradle verify
   ```

3. **Check Configuration:**
   ```bash
   gradle info
   ```

4. **Report Issues:**
   - [Bearsampp Issues](https://github.com/bearsampp/bearsampp/issues)

## Migration Checklist

Use this checklist to track your migration progress:

- [ ] Backup current Ant setup
- [ ] Install/verify Java 8+
- [ ] Install/verify Gradle 7.0+
- [ ] Install/verify 7-Zip (if using 7z format)
- [ ] Review build.properties (no changes needed)
- [ ] Run `gradle verify` to check environment
- [ ] Run `gradle listVersions` to see available versions
- [ ] Test build with `gradle release -PbundleVersion=X.X.X`
- [ ] Verify output in bearsampp-build directory
- [ ] Update any batch scripts or CI/CD configs
- [ ] Remove old Ant files (optional)
- [ ] Update team documentation

## Post-Migration

### Best Practices

1. **Use Version Control**
   - Commit build.gradle and settings.gradle
   - Add .gradle/ to .gitignore
   - Document any custom configurations

2. **Standardize Commands**
   - Use consistent task names across team
   - Document common workflows
   - Create helper scripts if needed

3. **Automate Verification**
   - Run `gradle verify` before builds
   - Include in CI/CD pipelines
   - Check environment regularly

4. **Monitor Build Performance**
   - Track build times
   - Optimize if needed
   - Use Gradle build cache

### Training Resources

- [Gradle User Manual](https://docs.gradle.org/current/userguide/userguide.html)
- [Quick Start Guide](QUICK_START.md)
- [Task Reference](TASKS.md)
- [Examples](EXAMPLES.md)

## Rollback Plan

If you need to rollback to Ant:

1. **Restore Ant Files:**
   ```bash
   copy backup-ant\build.xml .
   ```

2. **Use Ant Commands:**
   ```bash
   ant release.build
   ```

3. **Keep Both Systems:**
   - Ant and Gradle can coexist
   - Use different output directories
   - Migrate gradually

## Success Criteria

Your migration is successful when:

- ✓ `gradle verify` passes all checks
- ✓ `gradle release -PbundleVersion=X.X.X` builds successfully
- ✓ Output archives match Ant build output
- ✓ Hash files are generated correctly
- ✓ Team members can build using Gradle
- ✓ CI/CD pipelines updated and working

## Summary

The migration from Ant to Gradle provides:

- **Modern build system** with better tooling
- **Improved flexibility** with configurable paths
- **Better user experience** with interactive mode
- **Enhanced validation** with verify tasks
- **Automatic features** like hash generation
- **Consistent behavior** across environments

**Estimated Migration Time:** 30-60 minutes

---

**Need Help?** See the [Troubleshooting Guide](TROUBLESHOOTING.md) or report issues on the [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues).
