# Troubleshooting Guide

Solutions to common problems when building the Bearsampp Composer module with Gradle.

## Quick Diagnosis

Run these commands to diagnose issues:

```bash
# Check environment
gradle verify

# Check configuration
gradle info

# Validate properties
gradle validateProperties

# List available versions
gradle listVersions
```

## Common Issues

### Environment Issues

#### Java Not Found

**Symptoms:**
```
'java' is not recognized as an internal or external command
```

**Cause:** Java is not installed or not in PATH

**Solutions:**

1. **Install Java:**
   - Download from [adoptium.net](https://adoptium.net/)
   - Install Java 8 or higher
   - Verify: `java -version`

2. **Add Java to PATH:**
   ```bash
   # Windows Command Prompt
   set PATH=%PATH%;C:\Program Files\Java\jdk-17\bin
   
   # Windows PowerShell
   $env:PATH += ";C:\Program Files\Java\jdk-17\bin"
   ```

3. **Set JAVA_HOME:**
   ```bash
   # Windows Command Prompt
   set JAVA_HOME=C:\Program Files\Java\jdk-17
   
   # Windows PowerShell
   $env:JAVA_HOME="C:\Program Files\Java\jdk-17"
   ```

**Verification:**
```bash
java -version
# Should show: java version "17.0.2" or higher
```

---

#### Gradle Not Found

**Symptoms:**
```
'gradle' is not recognized as an internal or external command
```

**Cause:** Gradle is not installed or not in PATH

**Solutions:**

1. **Use Gradle Wrapper (Recommended):**
   ```bash
   # Windows
   gradlew.bat verify
   
   # Linux/macOS
   ./gradlew verify
   ```

2. **Install Gradle:**
   - Download from [gradle.org](https://gradle.org/install/)
   - Extract to C:\Gradle
   - Add to PATH: `C:\Gradle\bin`

3. **Verify Installation:**
   ```bash
   gradle --version
   ```

**Verification:**
```bash
gradle --version
# Should show: Gradle 7.0 or higher
```

---

#### 7-Zip Not Found

**Symptoms:**
```
7-Zip not found. Please install 7-Zip or set 7Z_HOME environment variable.
```

**Cause:** 7-Zip is not installed or not found in standard locations

**Solutions:**

1. **Install 7-Zip:**
   - Download from [7-zip.org](https://www.7-zip.org/)
   - Install to default location
   - Restart terminal

2. **Set 7Z_HOME Environment Variable:**
   ```bash
   # Windows Command Prompt
   set 7Z_HOME=C:\Program Files\7-Zip
   
   # Windows PowerShell
   $env:7Z_HOME="C:\Program Files\7-Zip"
   ```

3. **Use ZIP Format Instead:**
   Edit `build.properties`:
   ```properties
   bundle.format = zip
   ```

**Verification:**
```bash
# Windows
"C:\Program Files\7-Zip\7z.exe"
# Should show 7-Zip version info
```

---

### Configuration Issues

#### Build Properties Not Found

**Symptoms:**
```
build.properties not found
```

**Cause:** Missing or misplaced build.properties file

**Solutions:**

1. **Check File Location:**
   ```bash
   # Should be in project root
   dir build.properties
   ```

2. **Create build.properties:**
   ```properties
   bundle.name = composer
   bundle.release = 2025.8.15
   bundle.type = tools
   bundle.format = 7z
   ```

3. **Verify File Encoding:**
   - Should be UTF-8 or ISO-8859-1
   - No BOM (Byte Order Mark)

**Verification:**
```bash
gradle validateProperties
```

---

#### Invalid Property Values

**Symptoms:**
```
[ERROR] Missing required properties:
    - bundle.release
```

**Cause:** Required properties are missing or empty

**Solutions:**

1. **Check Required Properties:**
   ```properties
   bundle.name = composer
   bundle.release = 2025.8.15
   bundle.type = tools
   bundle.format = 7z
   ```

2. **Verify No Empty Values:**
   ```properties
   # Wrong
   bundle.name = 
   
   # Correct
   bundle.name = composer
   ```

3. **Check Property Names:**
   - Must match exactly (case-sensitive)
   - No extra spaces
   - No typos

**Verification:**
```bash
gradle validateProperties
```

---

#### Build Path Issues

**Symptoms:**
```
Cannot create directory: C:\Bearsampp-build\tools\composer
```

**Cause:** Invalid or inaccessible build path

**Solutions:**

1. **Check Path Syntax:**
   ```properties
   # Wrong (backslashes need escaping)
   build.path = C:\Bearsampp-build
   
   # Correct (forward slashes)
   build.path = C:/Bearsampp-build
   
   # Also correct (escaped backslashes)
   build.path = C:\\Bearsampp-build
   ```

2. **Check Permissions:**
   - Ensure write access to build path
   - Try a different location
   - Run as administrator (if needed)

3. **Use Environment Variable:**
   ```bash
   set BEARSAMPP_BUILD_PATH=C:\Bearsampp-build
   ```

4. **Use Default Path:**
   - Comment out build.path in build.properties
   - Let Gradle use default: `../bearsampp-build`

**Verification:**
```bash
gradle info
# Check "Build Base" path
```

---

### Build Issues

#### Version Not Found

**Symptoms:**
```
Bundle version not found: composer2.8.10

Available versions:
  - 2.8.9
  - 2.8.8
```

**Cause:** Specified version doesn't exist in bin/ directory

**Solutions:**

1. **List Available Versions:**
   ```bash
   gradle listVersions
   ```

2. **Check Directory Structure:**
   ```bash
   dir bin\
   # Should show: composer2.8.10\
   ```

3. **Check Archived Versions:**
   ```bash
   dir bin\archived\
   # May contain older versions
   ```

4. **Use Correct Version:**
   ```bash
   gradle release -PbundleVersion=2.8.9
   ```

**Verification:**
```bash
gradle listVersions
# Shows all available versions
```

---

#### Download Failed

**Symptoms:**
```
Failed to download composer.phar
Connection timeout
```

**Cause:** Network issues or invalid URL

**Solutions:**

1. **Check Internet Connection:**
   ```bash
   ping github.com
   ```

2. **Check Proxy Settings:**
   ```properties
   # gradle.properties
   systemProp.http.proxyHost=proxy.company.com
   systemProp.http.proxyPort=8080
   systemProp.https.proxyHost=proxy.company.com
   systemProp.https.proxyPort=8080
   ```

3. **Manual Download:**
   - Download composer.phar manually
   - Place in: `bearsampp-build/tmp/downloads/composer/`
   - Rename to: `composer-{version}.phar`

4. **Check releases.properties:**
   - Verify URL is correct
   - Test URL in browser

**Verification:**
```bash
# Test download
gradle downloadComposer -PcomposerVersion=2.8.10
```

---

#### Archive Creation Failed

**Symptoms:**
```
7zip compression failed with exit code: 2
```

**Cause:** 7-Zip error or insufficient disk space

**Solutions:**

1. **Check Disk Space:**
   ```bash
   # Ensure sufficient free space
   dir C:\
   ```

2. **Check 7-Zip Installation:**
   ```bash
   "C:\Program Files\7-Zip\7z.exe"
   ```

3. **Try ZIP Format:**
   ```properties
   # build.properties
   bundle.format = zip
   ```

4. **Check File Permissions:**
   - Ensure write access to output directory
   - Close any programs using the files

**Verification:**
```bash
gradle release -PbundleVersion=2.8.10
# Should complete without errors
```

---

#### Hash Generation Failed

**Symptoms:**
```
Failed to generate hash files
```

**Cause:** File access issues or corrupted archive

**Solutions:**

1. **Check Archive Exists:**
   ```bash
   dir bearsampp-build\tools\composer\2025.8.15\
   ```

2. **Check File Permissions:**
   - Ensure read access to archive
   - Ensure write access to directory

3. **Verify Archive Integrity:**
   - Try opening the archive
   - Check file size is reasonable

4. **Rebuild:**
   ```bash
   gradle clean
   gradle release -PbundleVersion=2.8.10
   ```

**Verification:**
```bash
# Check hash files exist
dir bearsampp-build\tools\composer\2025.8.15\*.md5
dir bearsampp-build\tools\composer\2025.8.15\*.sha1
dir bearsampp-build\tools\composer\2025.8.15\*.sha256
dir bearsampp-build\tools\composer\2025.8.15\*.sha512
```

---

### Task Issues

#### Task Not Found

**Symptoms:**
```
Task 'relase' not found in root project 'module-composer'.
```

**Cause:** Typo in task name

**Solutions:**

1. **List Available Tasks:**
   ```bash
   gradle tasks
   ```

2. **Check Task Name:**
   ```bash
   # Wrong
   gradle relase
   
   # Correct
   gradle release
   ```

3. **Common Task Names:**
   - `release` (not relase, realease, etc.)
   - `releaseAll` (camelCase)
   - `listVersions` (camelCase)

**Verification:**
```bash
gradle tasks --all
# Shows all available tasks
```

---

#### Task Failed

**Symptoms:**
```
FAILURE: Build failed with an exception.
```

**Cause:** Various reasons (see error message)

**Solutions:**

1. **Read Error Message:**
   - Scroll up to find the actual error
   - Look for "What went wrong:" section

2. **Run with Stack Trace:**
   ```bash
   gradle release -PbundleVersion=2.8.10 --stacktrace
   ```

3. **Run with Debug Output:**
   ```bash
   gradle release -PbundleVersion=2.8.10 --debug
   ```

4. **Clean and Retry:**
   ```bash
   gradle clean
   gradle release -PbundleVersion=2.8.10
   ```

**Verification:**
```bash
gradle verify
# Check environment is correct
```

---

### Interactive Mode Issues

#### Input Not Working

**Symptoms:**
```
Failed to read input. Please use non-interactive mode
```

**Cause:** Terminal doesn't support interactive input

**Solutions:**

1. **Use Non-Interactive Mode:**
   ```bash
   gradle release -PbundleVersion=2.8.10
   ```

2. **Use Different Terminal:**
   - Try Command Prompt instead of PowerShell
   - Try PowerShell instead of Command Prompt
   - Try Git Bash

3. **Check Terminal Settings:**
   - Ensure terminal is not in restricted mode
   - Check input redirection settings

**Verification:**
```bash
# Use non-interactive mode
gradle release -PbundleVersion=2.8.10
```

---

#### Version Selection Failed

**Symptoms:**
```
Invalid selection: 99. Please choose 1-21
```

**Cause:** Invalid version number entered

**Solutions:**

1. **Enter Valid Number:**
   - Must be between 1 and total versions
   - Must be an integer

2. **Enter Version String:**
   - Can enter full version (e.g., "2.8.10")
   - Must match exactly

3. **Use Non-Interactive Mode:**
   ```bash
   gradle release -PbundleVersion=2.8.10
   ```

**Verification:**
```bash
gradle listVersions
# Shows valid version numbers
```

---

## Performance Issues

### Slow Builds

**Symptoms:**
- Builds take longer than expected
- Gradle daemon slow to start

**Solutions:**

1. **Enable Gradle Daemon:**
   ```properties
   # gradle.properties
   org.gradle.daemon=true
   ```

2. **Increase JVM Memory:**
   ```properties
   # gradle.properties
   org.gradle.jvmargs=-Xmx4g
   ```

3. **Enable Parallel Execution:**
   ```properties
   # gradle.properties
   org.gradle.parallel=true
   ```

4. **Enable Build Cache:**
   ```properties
   # gradle.properties
   org.gradle.caching=true
   ```

5. **Use Local Cache:**
   - Downloaded files are cached
   - Reused across builds

**Verification:**
```bash
gradle release -PbundleVersion=2.8.10
# Second run should be faster
```

---

### Out of Memory

**Symptoms:**
```
java.lang.OutOfMemoryError: Java heap space
```

**Cause:** Insufficient JVM memory

**Solutions:**

1. **Increase Heap Size:**
   ```properties
   # gradle.properties
   org.gradle.jvmargs=-Xmx4g
   ```

2. **Close Other Applications:**
   - Free up system memory
   - Close unnecessary programs

3. **Use 64-bit Java:**
   - Allows more memory allocation
   - Check: `java -version`

**Verification:**
```bash
gradle release -PbundleVersion=2.8.10
# Should complete without memory errors
```

---

## Advanced Troubleshooting

### Enable Debug Logging

```bash
gradle release -PbundleVersion=2.8.10 --debug > build.log 2>&1
```

### Check Gradle Configuration

```bash
gradle properties
```

### Refresh Dependencies

```bash
gradle --refresh-dependencies
```

### Clear Gradle Cache

```bash
# Windows
rmdir /s /q %USERPROFILE%\.gradle\caches

# Linux/macOS
rm -rf ~/.gradle/caches
```

### Verify File Integrity

```bash
# Check archive
7z t bearsampp-build\tools\composer\2025.8.15\bearsampp-composer-2.8.10-2025.8.15.7z

# Verify hash
certutil -hashfile bearsampp-build\tools\composer\2025.8.15\bearsampp-composer-2.8.10-2025.8.15.7z MD5
```

---

## Getting Help

### Self-Help Resources

1. **Documentation:**
   - [Quick Start Guide](QUICK_START.md)
   - [Configuration Guide](CONFIG.md)
   - [Task Reference](TASKS.md)

2. **Diagnostic Commands:**
   ```bash
   gradle verify
   gradle info
   gradle validateProperties
   gradle listVersions
   ```

3. **Gradle Documentation:**
   - [Gradle User Manual](https://docs.gradle.org/current/userguide/userguide.html)
   - [Gradle Forums](https://discuss.gradle.org/)

### Community Support

1. **Bearsampp Issues:**
   - [GitHub Issues](https://github.com/bearsampp/bearsampp/issues)
   - Search existing issues first
   - Provide detailed error messages

2. **Information to Include:**
   - Operating system and version
   - Java version (`java -version`)
   - Gradle version (`gradle --version`)
   - Full error message
   - Output of `gradle info`
   - Output of `gradle verify`

### Reporting Bugs

When reporting bugs, include:

```bash
# System information
java -version
gradle --version

# Environment check
gradle verify

# Configuration
gradle info

# Error with stack trace
gradle release -PbundleVersion=2.8.10 --stacktrace
```

---

## Troubleshooting Checklist

Use this checklist to diagnose issues:

- [ ] Java 8+ installed and in PATH
- [ ] Gradle 7.0+ installed or wrapper available
- [ ] 7-Zip installed (if using 7z format)
- [ ] build.properties exists and is valid
- [ ] releases.properties exists
- [ ] bin/ directory contains versions
- [ ] Internet connection available
- [ ] Sufficient disk space
- [ ] Write permissions to build directory
- [ ] No antivirus blocking Gradle
- [ ] Correct version specified
- [ ] No typos in task names

---

## Summary

Most issues can be resolved by:

1. **Verifying environment:** `gradle verify`
2. **Checking configuration:** `gradle info`
3. **Using correct syntax:** `gradle tasks`
4. **Reading error messages carefully**
5. **Consulting documentation**

**Still stuck?** Report an issue on the [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues) with full details.
