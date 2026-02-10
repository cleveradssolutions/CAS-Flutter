import os

_PLUGIN_VERSION = "4.6.0"
_CAS_VERSION = "4.6.0"

# Plugin publishing flow (from the project root):
# python3 updater.py
# [write CHANGELOG.md]
# dart format .
# flutter analyze
# cd example && flutter build apk --debug
# cd example && flutter build ios --no-codesign
# flutter pub publish

def update_version_in_file(file_path, prefix, suffix):
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    success = False
    with open(file_path, 'w', encoding='utf-8') as file:
        for line in lines:
            if line.startswith(prefix):
                file.write(prefix + suffix + '\n')
                success = True
            else:
                file.write(line)
    
    if success:
        print("Updated " + file_path)
    else:
        raise RuntimeError(f"Prefix {prefix} not found in file: {file_path}")


def update_cas_sdk_version_android():
    update_version_in_file(
        os.path.join('android', 'build.gradle'),
        "        implementation 'com.cleveradssolutions:cas-sdk:",
        _CAS_VERSION + "'"
    )


def update_cas_sdk_version_android_example():
    update_version_in_file(
        os.path.join('example', 'android', 'app', 'build.gradle'),
        '    id("com.cleveradssolutions.gradle-plugin") version "',
        _CAS_VERSION + '"'
    )


def update_cas_sdk_version_ios():
    update_version_in_file(
        os.path.join('ios', 'clever_ads_solutions.podspec'),
        "  s.dependency 'CleverAdsSolutions-Base', '",
        "~> " + _CAS_VERSION + "'"
    )


def update_cas_sdk_version_ios_example():
    update_version_in_file(
        os.path.join('example', 'ios', 'Podfile'),
        "$casVersion = '",
        _CAS_VERSION + "'"
    )


def update_flutter_plugin_version():
    update_version_in_file(
        os.path.join('pubspec.yaml'),
        "version: ",
        _PLUGIN_VERSION
    )


def update_flutter_plugin_version_dart():
    update_version_in_file(
        os.path.join('android', 'src', 'main', 'kotlin', 'com', 'cleveradssolutions', 'plugin', 'flutter', 'CASMobileAdsPlugin.kt'),
        'private const val PLUGIN_VERSION = "',
        _PLUGIN_VERSION + '"'
    )
    update_version_in_file(
        os.path.join('ios', 'Classes', 'CASMobileAdsPlugin.swift'),
        'private let pluginVersion = "',
        _PLUGIN_VERSION + '"'
    )


def update_flutter_plugin_version_android():
    update_version_in_file(
        os.path.join('android', 'build.gradle'),
        "version = '",
        _PLUGIN_VERSION + "'"
    )


def update_flutter_plugin_version_ios():
    update_version_in_file(
        os.path.join('ios', 'clever_ads_solutions.podspec'),
        "  s.version          = '",
        _PLUGIN_VERSION + "'"
    )


if __name__ == "__main__":
    update_cas_sdk_version_android()
    update_cas_sdk_version_android_example()
    update_cas_sdk_version_ios()
    update_cas_sdk_version_ios_example()
    update_flutter_plugin_version()
    update_flutter_plugin_version_dart()
    update_flutter_plugin_version_android()
    update_flutter_plugin_version_ios()
