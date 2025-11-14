# Gradle Build Updates - Module Composer

## Overview
Synchronized the Gradle build configuration with the `module-apache` reference repository (gradle-convert branch) to ensure consistent build behavior across all Bearsampp modules.

## Changes Made

### 1. Build Path Configuration
- **Added configurable build base path** with priority system:
  1. `build.path` property in `build.properties`
  2. `BEARSAMPP_BUILD_PATH` environment variable
  3. Default: `${rootDir}/bearsampp-build`
- **Updated output structure** to: `{buildBasePath}/{bundleType}/{bundleName}/{bundleRelease}`
  - Example: `bearsampp-build/tools/composer/2025.8.15/`

### 2. 7-Zip Executable Detection
- **Implemented `find7ZipExecutable()` function** for consistency with other modules
- **Added 7Z_HOME environment variable support** for custom 7-Zip locations
- **Expanded search paths** to include D: drive installations
- **Improved error messages** to mention 7Z_HOME environment variable

### 3. Version Management
- **Implemented `getAvailableVersions()` function**
  - Returns flat list of version strings
  - Automatically checks both `bin/` and `bin/archived/` directories
  - Removes duplicates and sorts versions
- **Enhanced interactive version selection**
  - Shows location tags `[bin]` or `[bin/archives]` for each version
  - Improved formatting with proper padding
  - Better error messages for invalid selections

### 4. Task Improvements

#### `info` Task
- Added comprehensive build information display
- Shows all relevant paths and configuration
- Displays Java and Gradle environment details

#### `listVersions` Task
- Lists all available versions from bin/ and bin/archived/
- Shows location tag for each version
- Cleaner display with consistent formatting

#### `verify` Task
- Checks Java version (8+)
- Verifies required files (build.properties, releases.properties)
- Checks dev directory existence
- Validates bin directory
- Checks 7-Zip availability when format is 7z

#### `release` Task
- Builds release package for specified version
- Supports interactive mode (prompts for version)
- Non-interactive mode with `-PbundleVersion=X.X.X`
- Generates hash files (MD5, SHA1, SHA256, SHA512)
- Uses new build path structure

#### `releaseAll` Task
- Builds all available versions in bin/ and bin/archived/
- Provides detailed progress and summary
- Lists failed versions if any

#### `listReleases` Task
- Lists all versions from releases.properties
- Shows download URLs for each version

#### `validateProperties` Task
- Validates build.properties configuration
- Checks for required properties

#### `downloadComposer` Task
- Downloads Composer PHAR file directly
- Usage: `gradle downloadComposer -PcomposerVersion=X.X.X`

### 5. Settings File
- **Created `settings.gradle`** with:
  - Project name: `module-composer`
  - Stable configuration cache feature preview
  - Local build cache configuration
  - Initialization message display

### 6. Build Properties
- **Created `build.properties`** with:
  - `bundle.name = composer`
  - `bundle.release = 2025.8.15`
  - `bundle.type = tools`
  - `bundle.format = 7z`
  - Optional `build.path` configuration

### 7. Code Consistency
- Aligned function names with Apache module conventions
- Standardized error messages and user prompts
- Improved code comments and documentation
- Consistent formatting throughout

## New Features

### Configurable Build Path
You can now configure the build output path in three ways:

1. **In build.properties:**
   ```properties
   build.path = C:/Bearsampp-build
   ```

2. **Environment variable:**
   ```bash
   set BEARSAMPP_BUILD_PATH=C:/Bearsampp-build
   ```

3. **Default:** Uses `../bearsampp-build` relative to project root

### Archived Versions Support
The build system now automatically detects and supports versions in both:
- `bin/` - Current/active versions
- `bin/archived/` - Archived/older versions

Both locations are checked when building or listing versions.

### Enhanced 7-Zip Detection
Set the `7Z_HOME` environment variable to specify a custom 7-Zip installation:
```bash
set 7Z_HOME=D:\Tools\7-Zip
```

### Hash File Generation
All release archives automatically generate hash files:
- MD5
- SHA1
- SHA256
- SHA512

## Usage Examples

### List all available versions
```bash
gradle listVersions
```

### Build a specific version
```bash
gradle release -PbundleVersion=2.8.10
```

### Interactive build (prompts for version)
```bash
gradle release
```

### Build all versions
```bash
gradle releaseAll
```

### Verify build environment
```bash
gradle verify
```

### Display build information
```bash
gradle info
```

### List releases from releases.properties
```bash
gradle listReleases
```

### Download Composer PHAR
```bash
gradle downloadComposer -PcomposerVersion=2.8.10
```

## Output Structure

Archives are now created in:
```
{buildBasePath}/{bundleType}/{bundleName}/{bundleRelease}/
```

Example:
```
bearsampp-build/
  tools/
    composer/
      2025.8.15/
        bearsampp-composer-2.8.10-2025.8.15.7z
        bearsampp-composer-2.8.10-2025.8.15.7z.md5
        bearsampp-composer-2.8.10-2025.8.15.7z.sha1
        bearsampp-composer-2.8.10-2025.8.15.7z.sha256
        bearsampp-composer-2.8.10-2025.8.15.7z.sha512
```

## Compatibility

- Fully compatible with existing `build.properties` configuration
- Backward compatible with existing bin directory structure
- Works with both current and archived version directories
- Supports both 7z and zip archive formats

## Testing

All tasks have been tested and verified:
- ✅ `gradle info` - Displays build information correctly
- ✅ `gradle listVersions` - Lists all versions from bin/ and bin/archived/
- ✅ `gradle verify` - Checks environment including 7-Zip
- ✅ `gradle release -PbundleVersion=2.8.10` - Builds release successfully
- ✅ Build path resolution works with all three priority levels
- ✅ Interactive version selection displays location tags
- ✅ Archive creation follows new path structure
- ✅ Hash files generated correctly

## Migration Notes

If you have an existing `build.path` property in `build.properties`, it will continue to work as before. The new priority system ensures backward compatibility while adding flexibility through environment variables.

## Composer-Specific Notes

Unlike Apache which requires downloading and extracting binary distributions, Composer is a simpler PHP tool that consists of:
- `composer.bat` - Windows batch script
- `composer.json` - Configuration file
- `bearsampp.conf` - Bearsampp-specific configuration

The build process simply packages these files from the `bin/` directory structure.

## Reference

Based on: https://github.com/Bearsampp/module-apache/tree/gradle-convert
