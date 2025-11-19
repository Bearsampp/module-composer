@echo off

REM Set COMPOSER_HOME to the directory of the batch file
set COMPOSER_HOME=%~dp0

REM Check if phpunit/phpunit is not installed
@php "%~dp0composer.phar" show --quiet phpunit/phpunit || (
    echo phpunit/phpunit is not installed. Installing...
    @php "%~dp0composer.phar" require --dev phpunit/phpunit
)

REM Run composer install
@php "%~dp0composer.phar" install %*
