import os
import re

CAS_VERSION = '3.9.1'
FLUTTER_PLUGIN_VERSION = '0.5.0'


def update_version_in_file(file_path, version_prefix, new_version, file_description):
    with open(file_path, 'r') as file:
        content = file.read()

    content, count = re.subn(
        rf"{re.escape(version_prefix)}(\d+\.\d+\.\d+)",
        f"{version_prefix}{new_version}",
        content,
        count = 1
    )

    if count > 0:
        with open(file_path, 'w') as file:
            file.write(content)
        print(f"{file_description} updated to {new_version}")
    else:
        print(f"{file_description} not found")


def update_cas_sdk_version_android():
    update_version_in_file(
        os.path.join('..', 'android', 'build.gradle'),
        "com.cleveradssolutions:cas-sdk:",
        CAS_VERSION,
        "[Android] [build.gradle] CAS SDK version"
    )


def update_cas_sdk_version_android_example():
    update_version_in_file(
        os.path.join('..', 'example', 'android', 'app', 'build.gradle'),
        "com.cleveradssolutions:cas-families:",
        CAS_VERSION,
        "[Android example] [build.gradle]"
    )


def update_cas_sdk_version_ios():
    update_version_in_file(
        os.path.join('..', 'ios', 'clever_ads_solutions.podspec'),
        "'CleverAdsSolutions-Base', '~> ",
        CAS_VERSION,
        "[iOS] [podspec] CAS SDK version"
    )


def update_cas_sdk_version_ios_example():
    update_version_in_file(
        os.path.join('..', 'example', 'ios', 'Podfile'),
        "$casVersion = '~> ",
        CAS_VERSION,
        "[iOS example] [Podfile] CAS SDK version"
    )


def update_flutter_plugin_version():
    update_version_in_file(
        os.path.join('..', 'pubspec.yaml'),
        "version: ",
        FLUTTER_PLUGIN_VERSION,
        "[Flutter] [pubspec.yaml] CAS Flutter plugin version"
    )


def update_flutter_plugin_version_dart():
    update_version_in_file(
        os.path.join('..', 'lib', 'public', 'cas.dart'),
        "static const String _pluginVersion = \"",
        FLUTTER_PLUGIN_VERSION,
        "[Flutter] [cas.dart] CAS Flutter plugin version"
    )


def update_flutter_plugin_version_android():
    update_version_in_file(
        os.path.join('..', 'android', 'build.gradle'),
        "version = '",
        FLUTTER_PLUGIN_VERSION,
        "[Android] [build.gradle] CAS Flutter plugin version"
    )


def update_flutter_plugin_version_ios():
    update_version_in_file(
        os.path.join('..', 'ios', 'clever_ads_solutions.podspec'),
        "version          = '",
        FLUTTER_PLUGIN_VERSION,
        "[iOS] [podspec] CAS Flutter plugin version"
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
