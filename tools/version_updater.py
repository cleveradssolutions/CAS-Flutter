import os
import re
import sys


# To run, execute the command:
# python version_updater.py CAS_VERSION=3.9.6 FLUTTER_PLUGIN_VERSION=0.6.1

def parse_args(args):
    cas_version = None
    flutter_plugin_version = None

    for arg in args:
        if arg.startswith("CAS_VERSION="):
            cas_version = arg.split("=")[1]
        elif arg.startswith("FLUTTER_PLUGIN_VERSION="):
            flutter_plugin_version = arg.split("=")[1]

    if not cas_version or not flutter_plugin_version:
        raise ValueError("Both CAS_VERSION and FLUTTER_PLUGIN_VERSION must be provided.")

    return cas_version, flutter_plugin_version


def update_version_in_file(file_path, version_prefix, new_version, file_description):
    with open(file_path, 'r') as file:
        content = file.read()

    content, count = re.subn(
        rf"{re.escape(version_prefix)}(\d+\.\d+\.\d+)",
        f"{version_prefix}{new_version}",
        content,
        count=1
    )

    if count > 0:
        with open(file_path, 'w') as file:
            file.write(content)
        print(f"{file_description} updated to {new_version}")
    else:
        print(f"{file_description} not found")


def update_cas_sdk_version_android(cas_version):
    update_version_in_file(
        os.path.join('..', 'android', 'build.gradle'),
        "com.cleveradssolutions:cas-sdk:",
        cas_version,
        "[Android] [build.gradle] CAS SDK version"
    )


def update_cas_sdk_version_android_example(cas_version):
    update_version_in_file(
        os.path.join('..', 'example', 'android', 'app', 'build.gradle'),
        "id(\"com.cleveradssolutions.gradle-plugin\") version \"",
        cas_version,
        "[Android example] [build.gradle]"
    )


def update_cas_sdk_version_ios(cas_version):
    update_version_in_file(
        os.path.join('..', 'ios', 'clever_ads_solutions.podspec'),
        "'CleverAdsSolutions-Base', '~> ",
        cas_version,
        "[iOS] [podspec] CAS SDK version"
    )


def update_cas_sdk_version_ios_example(cas_version):
    update_version_in_file(
        os.path.join('..', 'example', 'ios', 'Podfile'),
        "$casVersion = '~> ",
        cas_version,
        "[iOS example] [Podfile] CAS SDK version"
    )


def update_flutter_plugin_version(flutter_plugin_version):
    update_version_in_file(
        os.path.join('..', 'pubspec.yaml'),
        "version: ",
        flutter_plugin_version,
        "[Flutter] [pubspec.yaml] CAS Flutter plugin version"
    )


def update_flutter_plugin_version_dart(flutter_plugin_version):
    update_version_in_file(
        os.path.join('..', 'lib', 'src', 'cas.dart'),
        "static const String _pluginVersion = \"",
        flutter_plugin_version,
        "[Flutter] [cas.dart] CAS Flutter plugin version"
    )


def update_flutter_plugin_version_android(flutter_plugin_version):
    update_version_in_file(
        os.path.join('..', 'android', 'build.gradle'),
        "version = '",
        flutter_plugin_version,
        "[Android] [build.gradle] CAS Flutter plugin version"
    )


def update_flutter_plugin_version_ios(flutter_plugin_version):
    update_version_in_file(
        os.path.join('..', 'ios', 'clever_ads_solutions.podspec'),
        "version          = '",
        flutter_plugin_version,
        "[iOS] [podspec] CAS Flutter plugin version"
    )


if __name__ == "__main__":
    cas_version, flutter_plugin_version = parse_args(sys.argv[1:])
    update_cas_sdk_version_android(cas_version)
    update_cas_sdk_version_android_example(cas_version)
    update_cas_sdk_version_ios(cas_version)
    update_cas_sdk_version_ios_example(cas_version)
    update_flutter_plugin_version(flutter_plugin_version)
    update_flutter_plugin_version_dart(flutter_plugin_version)
    update_flutter_plugin_version_android(flutter_plugin_version)
    update_flutter_plugin_version_ios(flutter_plugin_version)
