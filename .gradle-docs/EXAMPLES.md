# Usage Examples

Real-world examples and workflows for building Bearsampp Composer modules with Gradle.

## Table of Contents

- [Basic Examples](#basic-examples)
- [Development Workflows](#development-workflows)
- [CI/CD Integration](#cicd-integration)
- [Advanced Scenarios](#advanced-scenarios)
- [Batch Scripts](#batch-scripts)

## Basic Examples

### Example 1: First Build

Build your first Composer module release.

```bash
# Step 1: Verify environment
gradle verify

# Step 2: List available versions
gradle listVersions

# Step 3: Build a specific version
gradle release -PbundleVersion=2.8.10

# Step 4: Verify output
dir bearsampp-build\tools\composer\2025.8.15\
```

**Expected Output:**
```
bearsampp-composer-2.8.10-2025.8.15.7z
bearsampp-composer-2.8.10-2.8.15.7z.md5
bearsampp-composer-2.8.10-2025.8.15.7z.sha1
bearsampp-composer-2.8.10-2025.8.15.7z.sha256
bearsampp-composer-2.8.10-2025.8.15.7z.sha512
```

---

### Example 2: Interactive Build

Use interactive mode to select a version.

```bash
# Start interactive build
gradle release

# Output shows available versions:
# ======================================================================
# Available composer versions:
# ======================================================================
#   1. 2.8.10          [bin]
#   2. 2.8.9           [bin]
#   3. 2.8.8           [bin/archived]
#   ...
# ======================================================================
# 
# Enter version number or full version string:

# Enter: 1
# (or enter: 2.8.10)

# Build proceeds automatically
```

---

### Example 3: Build Multiple Versions

Build several specific versions.

```bash
# Build version 2.8.10
gradle release -PbundleVersion=2.8.10

# Build version 2.8.9
gradle release -PbundleVersion=2.8.9

# Build version 2.8.8
gradle release -PbundleVersion=2.8.8
```

---

### Example 4: Build All Versions

Build all available versions at once.

```bash
# Build all versions
gradle releaseAll

# Output shows progress:
# ======================================================================
# Building releases for 21 composer versions
# ======================================================================
# 
# ======================================================================
# [1/21] Building composer 2.8.10...
# ======================================================================
# ...
# [SUCCESS] composer 2.8.10 completed
# 
# ======================================================================
# Build Summary
# ======================================================================
# Total versions: 21
# Successful:     21
# Failed:         0
# ======================================================================
```

---

### Example 5: Clean Build

Clean and rebuild from scratch.

```bash
# Clean previous builds
gradle clean

# Build fresh
gradle release -PbundleVersion=2.8.10
```

---

## Development Workflows

### Workflow 1: Daily Development

Typical daily development workflow.

```bash
# Morning: Check environment
gradle verify

# List what's available
gradle listVersions

# Build latest version for testing
gradle release -PbundleVersion=2.8.10

# Test the build
# ... testing ...

# Clean up if needed
gradle clean
```

---

### Workflow 2: New Version Release

Adding and building a new Composer version.

```bash
# Step 1: Add version to releases.properties
echo 2.9.0 = https://getcomposer.org/download/2.9.0/composer.phar >> releases.properties

# Step 2: Create version directory
mkdir bin\composer2.9.0

# Step 3: Copy configuration files
copy bin\composer2.8.10\composer.bat bin\composer2.9.0\
copy bin\composer2.8.10\composer.json bin\composer2.9.0\
copy bin\composer2.8.10\bearsampp.conf bin\composer2.9.0\

# Step 4: Update version-specific settings
notepad bin\composer2.9.0\bearsampp.conf

# Step 5: Verify version is detected
gradle listVersions

# Step 6: Build new version
gradle release -PbundleVersion=2.9.0

# Step 7: Test the build
# ... testing ...

# Step 8: Commit changes
git add releases.properties bin\composer2.9.0\
git commit -m "Add Composer 2.9.0"
```

---

### Workflow 3: Testing Configuration Changes

Test configuration changes without full rebuild.

```bash
# Step 1: Modify build.properties
notepad build.properties

# Step 2: Validate changes
gradle validateProperties

# Step 3: Check configuration
gradle info

# Step 4: Test build
gradle release -PbundleVersion=2.8.10

# Step 5: Verify output location
dir bearsampp-build\tools\composer\2025.8.15\
```

---

### Workflow 4: Archive Format Testing

Test different archive formats.

```bash
# Test with 7z format
echo bundle.format = 7z > build.properties.test
gradle release -PbundleVersion=2.8.10

# Test with zip format
echo bundle.format = zip > build.properties.test
gradle release -PbundleVersion=2.8.10

# Compare file sizes
dir bearsampp-build\tools\composer\2025.8.15\*.7z
dir bearsampp-build\tools\composer\2025.8.15\*.zip
```

---

## CI/CD Integration

### Example 1: GitHub Actions

Complete GitHub Actions workflow.

```yaml
# .github/workflows/build.yml
name: Build Composer Module

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:
    inputs:
      version:
        description: 'Composer version to build'
        required: true
        default: '2.8.10'

jobs:
  build:
    runs-on: windows-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '17'
      
      - name: Setup 7-Zip
        run: |
          choco install 7zip -y
      
      - name: Verify environment
        run: gradle verify
      
      - name: List available versions
        run: gradle listVersions
      
      - name: Build release
        run: gradle release -PbundleVersion=${{ github.event.inputs.version || '2.8.10' }}
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: composer-${{ github.event.inputs.version || '2.8.10' }}
          path: bearsampp-build/tools/composer/**/*
      
      - name: Generate build summary
        run: |
          echo "## Build Summary" >> $GITHUB_STEP_SUMMARY
          echo "- Version: ${{ github.event.inputs.version || '2.8.10' }}" >> $GITHUB_STEP_SUMMARY
          echo "- Status: Success" >> $GITHUB_STEP_SUMMARY
```

---

### Example 2: Jenkins Pipeline

Jenkins declarative pipeline.

```groovy
// Jenkinsfile
pipeline {
    agent {
        label 'windows'
    }
    
    parameters {
        choice(
            name: 'VERSION',
            choices: ['2.8.10', '2.8.9', '2.8.8'],
            description: 'Composer version to build'
        )
        booleanParam(
            name: 'BUILD_ALL',
            defaultValue: false,
            description: 'Build all versions'
        )
    }
    
    environment {
        BEARSAMPP_BUILD_PATH = "${WORKSPACE}/build-output"
        JAVA_HOME = tool 'JDK17'
    }
    
    stages {
        stage('Verify Environment') {
            steps {
                bat 'gradle verify'
            }
        }
        
        stage('List Versions') {
            steps {
                bat 'gradle listVersions'
            }
        }
        
        stage('Build Single Version') {
            when {
                expression { !params.BUILD_ALL }
            }
            steps {
                bat "gradle release -PbundleVersion=${params.VERSION}"
            }
        }
        
        stage('Build All Versions') {
            when {
                expression { params.BUILD_ALL }
            }
            steps {
                bat 'gradle releaseAll'
            }
        }
        
        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'build-output/tools/composer/**/*', fingerprint: true
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Build completed successfully!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
```

---

### Example 3: GitLab CI

GitLab CI/CD configuration.

```yaml
# .gitlab-ci.yml
variables:
  BEARSAMPP_BUILD_PATH: "${CI_PROJECT_DIR}/build-output"

stages:
  - verify
  - build
  - deploy

verify:
  stage: verify
  script:
    - gradle verify
    - gradle listVersions
  only:
    - branches

build:single:
  stage: build
  script:
    - gradle release -PbundleVersion=${COMPOSER_VERSION}
  artifacts:
    paths:
      - build-output/tools/composer/
    expire_in: 1 week
  only:
    - branches
  variables:
    COMPOSER_VERSION: "2.8.10"

build:all:
  stage: build
  script:
    - gradle releaseAll
  artifacts:
    paths:
      - build-output/tools/composer/
    expire_in: 1 month
  only:
    - main
    - tags

deploy:
  stage: deploy
  script:
    - echo "Deploying to distribution server..."
    # Add deployment commands here
  only:
    - tags
```

---

## Advanced Scenarios

### Scenario 1: Custom Build Path

Build to a custom location.

```bash
# Method 1: Environment variable
set BEARSAMPP_BUILD_PATH=D:\Builds\Bearsampp
gradle release -PbundleVersion=2.8.10

# Method 2: build.properties
echo build.path = D:/Builds/Bearsampp >> build.properties
gradle release -PbundleVersion=2.8.10

# Verify output location
dir D:\Builds\Bearsampp\tools\composer\2025.8.15\
```

---

### Scenario 2: Network Drive Build

Build to a network share.

```bash
# Map network drive
net use Z: \\server\builds

# Set build path
set BEARSAMPP_BUILD_PATH=Z:\Bearsampp
gradle release -PbundleVersion=2.8.10

# Verify
dir Z:\Bearsampp\tools\composer\2025.8.15\
```

---

### Scenario 3: Parallel Builds

Build multiple versions in parallel (manual).

```bash
# Terminal 1
gradle release -PbundleVersion=2.8.10

# Terminal 2 (simultaneously)
gradle release -PbundleVersion=2.8.9

# Terminal 3 (simultaneously)
gradle release -PbundleVersion=2.8.8
```

---

### Scenario 4: Offline Build

Build without internet access (using cached files).

```bash
# Pre-download all versions (when online)
gradle downloadComposer -PcomposerVersion=2.8.10
gradle downloadComposer -PcomposerVersion=2.8.9
gradle downloadComposer -PcomposerVersion=2.8.8

# Later (offline)
gradle release -PbundleVersion=2.8.10
# Uses cached composer.phar files
```

---

### Scenario 5: Automated Testing

Build and test automatically.

```bash
# Build
gradle release -PbundleVersion=2.8.10

# Extract for testing
7z x bearsampp-build\tools\composer\2025.8.15\bearsampp-composer-2.8.10-2025.8.15.7z -otest\

# Test
cd test
composer.bat --version

# Verify version
composer.bat --version | findstr "2.8.10"

# Cleanup
cd ..
rmdir /s /q test
```

---

## Batch Scripts

### Script 1: Build Latest Version

```batch
@echo off
REM build-latest.bat
REM Build the latest Composer version

echo ========================================
echo Building Latest Composer Version
echo ========================================
echo.

REM Verify environment
echo Verifying environment...
gradle verify
if errorlevel 1 (
    echo ERROR: Environment verification failed!
    exit /b 1
)
echo.

REM Get latest version (assumes first in list)
echo Detecting latest version...
for /f "tokens=1" %%v in ('gradle -q listVersions ^| findstr /r "^  [0-9]"') do (
    set LATEST_VERSION=%%v
    goto :build
)

:build
echo Latest version: %LATEST_VERSION%
echo.

REM Build
echo Building release...
gradle release -PbundleVersion=%LATEST_VERSION%
if errorlevel 1 (
    echo ERROR: Build failed!
    exit /b 1
)

echo.
echo ========================================
echo Build completed successfully!
echo ========================================
```

---

### Script 2: Build and Deploy

```batch
@echo off
REM build-and-deploy.bat
REM Build and deploy to distribution server

setlocal enabledelayedexpansion

set VERSION=%1
if "%VERSION%"=="" (
    echo Usage: build-and-deploy.bat VERSION
    echo Example: build-and-deploy.bat 2.8.10
    exit /b 1
)

echo ========================================
echo Build and Deploy Composer %VERSION%
echo ========================================
echo.

REM Build
echo Building...
gradle release -PbundleVersion=%VERSION%
if errorlevel 1 (
    echo ERROR: Build failed!
    exit /b 1
)

REM Deploy
echo.
echo Deploying...
set SOURCE=bearsampp-build\tools\composer\2025.8.15\
set DEST=\\server\releases\composer\%VERSION%\

if not exist "%DEST%" mkdir "%DEST%"
copy "%SOURCE%\*" "%DEST%\"
if errorlevel 1 (
    echo ERROR: Deployment failed!
    exit /b 1
)

echo.
echo ========================================
echo Build and deployment completed!
echo ========================================
```

---

### Script 3: Nightly Build

```batch
@echo off
REM nightly-build.bat
REM Automated nightly build of all versions

echo ========================================
echo Nightly Build - %DATE% %TIME%
echo ========================================
echo.

REM Set log file
set LOGFILE=nightly-build-%DATE:~-4%-%DATE:~-7,2%-%DATE:~-10,2%.log

REM Verify environment
echo Verifying environment... >> %LOGFILE%
gradle verify >> %LOGFILE% 2>&1
if errorlevel 1 (
    echo ERROR: Environment verification failed! >> %LOGFILE%
    exit /b 1
)

REM Build all versions
echo Building all versions... >> %LOGFILE%
gradle releaseAll >> %LOGFILE% 2>&1
if errorlevel 1 (
    echo ERROR: Build failed! >> %LOGFILE%
    exit /b 1
)

REM Generate report
echo. >> %LOGFILE%
echo Build completed: %DATE% %TIME% >> %LOGFILE%
echo ======================================== >> %LOGFILE%

echo Nightly build completed. See %LOGFILE% for details.
```

---

### Script 4: Version Comparison

```batch
@echo off
REM compare-versions.bat
REM Compare archive sizes of different versions

echo ========================================
echo Composer Version Comparison
echo ========================================
echo.

set BUILD_DIR=bearsampp-build\tools\composer\2025.8.15

echo Version          Size (bytes)
echo --------         ------------

for %%f in (%BUILD_DIR%\bearsampp-composer-*.7z) do (
    set FILENAME=%%~nf
    set SIZE=%%~zf
    echo !FILENAME:~19,6!         !SIZE!
)

echo.
echo ========================================
```

---

### Script 5: Cleanup Old Builds

```batch
@echo off
REM cleanup-old-builds.bat
REM Remove builds older than 30 days

echo ========================================
echo Cleaning Old Builds
echo ========================================
echo.

set BUILD_DIR=bearsampp-build\tools\composer
set DAYS=30

echo Removing files older than %DAYS% days...
forfiles /p "%BUILD_DIR%" /s /m *.7z /d -%DAYS% /c "cmd /c del @path" 2>nul
forfiles /p "%BUILD_DIR%" /s /m *.md5 /d -%DAYS% /c "cmd /c del @path" 2>nul
forfiles /p "%BUILD_DIR%" /s /m *.sha* /d -%DAYS% /c "cmd /c del @path" 2>nul

echo.
echo Cleanup completed!
echo ========================================
```

---

## PowerShell Scripts

### Script 1: Build with Notification

```powershell
# build-with-notification.ps1
# Build and send notification

param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Building Composer $Version" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Build
    gradle release -PbundleVersion=$Version
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "Build successful!" -ForegroundColor Green
        
        # Send notification (Windows 10+)
        $notification = New-Object -ComObject Wscript.Shell
        $notification.Popup("Composer $Version build completed successfully!", 5, "Build Success", 64)
    } else {
        throw "Build failed with exit code $LASTEXITCODE"
    }
} catch {
    Write-Host ""
    Write-Host "Build failed: $_" -ForegroundColor Red
    
    # Send error notification
    $notification = New-Object -ComObject Wscript.Shell
    $notification.Popup("Composer $Version build failed!", 5, "Build Error", 16)
    
    exit 1
}
```

---

### Script 2: Build Report Generator

```powershell
# generate-build-report.ps1
# Generate HTML build report

$buildDir = "bearsampp-build\tools\composer\2025.8.15"
$reportFile = "build-report.html"

$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Composer Build Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>Composer Build Report</h1>
    <p>Generated: $(Get-Date)</p>
    <table>
        <tr>
            <th>Version</th>
            <th>Archive Size</th>
            <th>MD5</th>
            <th>SHA256</th>
        </tr>
"@

Get-ChildItem "$buildDir\*.7z" | ForEach-Object {
    $version = $_.Name -replace 'bearsampp-composer-(\d+\.\d+\.\d+)-.*', '$1'
    $size = "{0:N2} MB" -f ($_.Length / 1MB)
    $md5 = (Get-Content "$($_.FullName).md5" -Raw).Split()[0]
    $sha256 = (Get-Content "$($_.FullName).sha256" -Raw).Split()[0]
    
    $html += @"
        <tr>
            <td>$version</td>
            <td>$size</td>
            <td><code>$md5</code></td>
            <td><code>$sha256</code></td>
        </tr>
"@
}

$html += @"
    </table>
</body>
</html>
"@

$html | Out-File $reportFile -Encoding UTF8
Write-Host "Report generated: $reportFile"
Start-Process $reportFile
```

---

## Summary

These examples demonstrate:

- **Basic usage** - Simple build commands
- **Development workflows** - Daily development tasks
- **CI/CD integration** - Automated builds
- **Advanced scenarios** - Complex use cases
- **Batch scripts** - Windows automation
- **PowerShell scripts** - Advanced automation

**Next Steps:**
- Adapt examples to your needs
- Create custom scripts
- Integrate with your workflow
- See [Task Reference](TASKS.md) for more options

---

**Need more examples?** Check the [Configuration Guide](CONFIG.md) or ask on the [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues).
