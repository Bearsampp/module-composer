# Quick Start Guide

Get up and running with the Bearsampp Composer Gradle build in 5 minutes.

## Prerequisites

Before you begin, ensure you have:

| Requirement | Version     | Check Command              |
|-------------|-------------|----------------------------|
| Java        | 8 or higher | `java -version`            |
| 7-Zip       | Any version | `7z` or check Program Files|

## Step 1: Verify Your Environment

Run the verification task to check your setup:

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

[SUCCESS] All checks passed! Build environment is ready.
```

If any checks fail, see [Troubleshooting](TROUBLESHOOTING.md).

## Step 2: List Available Versions

See what Composer versions are available to build:

```bash
gradle listVersions
```

**Example Output:**
```
Available composer versions:
------------------------------------------------------------
  2.8.10          [bin]
  2.8.9           [bin]
  2.8.8           [bin/archived]
  ...
------------------------------------------------------------
Total versions: 21
```

## Step 3: Build a Release

Build a release for a specific version:

```bash
gradle release -PbundleVersion=2.8.10
```

**What Happens:**
1. Downloads composer.phar from modules-untouched repository
2. Copies configuration files from bin/composer2.8.10/
3. Creates archive: `bearsampp-composer-2.8.10-2025.8.15.7z`
4. Generates hash files (MD5, SHA1, SHA256, SHA512)

**Output Location:**
```
bearsampp-build/tools/composer/2025.8.15/
```

## Step 4: Verify the Build

Check that your build was successful:

```bash
# List the output directory
dir bearsampp-build\tools\composer\2025.8.15

# You should see:
# bearsampp-composer-2.8.10-2025.8.15.7z
# bearsampp-composer-2.8.10-2025.8.15.7z.md5
# bearsampp-composer-2.8.10-2025.8.15.7z.sha1
# bearsampp-composer-2.8.10-2025.8.15.7z.sha256
# bearsampp-composer-2.8.10-2025.8.15.7z.sha512
```

## Interactive Mode

You can also build interactively without specifying a version:

```bash
gradle release
```

The build will prompt you to select a version from the available list.

## Common Tasks

| Task                                    | Description                              |
|-----------------------------------------|------------------------------------------|
| `gradle info`                           | Display build configuration              |
| `gradle tasks`                          | List all available tasks                 |
| `gradle verify`                         | Verify build environment                 |
| `gradle listVersions`                   | List available versions                  |
| `gradle release -PbundleVersion=X.X.X`  | Build specific version                   |
| `gradle releaseAll`                     | Build all versions                       |
| `gradle clean`                          | Clean build artifacts                    |

## Next Steps

### Build Multiple Versions

To build all available versions at once:

```bash
gradle releaseAll
```

### Configure Build Path

To change where builds are output, edit `build.properties`:

```properties
build.path = C:/Bearsampp-build
```

Or set an environment variable:

```bash
set BEARSAMPP_BUILD_PATH=C:/Bearsampp-build
```

### Learn More

- [Task Reference](TASKS.md) - Complete list of all tasks
- [Configuration Guide](CONFIG.md) - Detailed configuration options
- [Examples](EXAMPLES.md) - More usage examples

## Troubleshooting

### Java Not Found

**Error:** `'java' is not recognized as an internal or external command`

**Solution:** Install Java 8 or higher and add it to your PATH.

### 7-Zip Not Found

**Error:** `7-Zip not found. Please install 7-Zip or set 7Z_HOME environment variable.`

**Solution:** 
1. Install 7-Zip from [7-zip.org](https://www.7-zip.org/)
2. Or set `7Z_HOME` environment variable:
   ```bash
   set 7Z_HOME=C:\Program Files\7-Zip
   ```

### Version Not Found

**Error:** `Bundle version not found: composer2.8.10`

**Solution:** Run `gradle listVersions` to see available versions.

### More Help

See the complete [Troubleshooting Guide](TROUBLESHOOTING.md) for more solutions.

## Summary

You've successfully:
- ✅ Verified your build environment
- ✅ Listed available versions
- ✅ Built a release package
- ✅ Generated hash files

**Congratulations!** You're now ready to build Bearsampp Composer modules.

---

**Need Help?** Check the [full documentation](./) or report issues on the [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues).
