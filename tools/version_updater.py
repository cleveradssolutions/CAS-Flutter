import os
import re
import sys

_FLUTTER_PLUGIN_VERSION = "0.8.7"
_CAS_VERSION = "4.2.1"

# Plugin publishing flow (from the project root):
# python3 tools/version_updater.py
# python3 tools/generate_export_file.py
# [write CHANGELOG.md]
# dart format .
# flutter analyze
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
        "    implementation 'com.cleveradssolutions:cas-sdk:",
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
        ">= " + _CAS_VERSION + "'"
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
        _FLUTTER_PLUGIN_VERSION
    )


def update_flutter_plugin_version_dart():
    update_version_in_file(
        os.path.join('lib', 'src', 'cas.dart'),
        '  static const String _pluginVersion = "',
        _FLUTTER_PLUGIN_VERSION + '";'
    )


def update_flutter_plugin_version_android():
    update_version_in_file(
        os.path.join('android', 'build.gradle'),
        "version = '",
        _FLUTTER_PLUGIN_VERSION + "'"
    )


def update_flutter_plugin_version_ios():
    update_version_in_file(
        os.path.join('ios', 'clever_ads_solutions.podspec'),
        "  s.version          = '",
        _FLUTTER_PLUGIN_VERSION + "'"
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
