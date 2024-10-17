import os
import re


# Run to generate clever_ads_solutions.dart

def is_entire_file_deprecated(file_path):
    with open(file_path, "r") as f:
        content = f.read()
        entities = re.findall(r'\s*(class|enum|def|typedef|extension|mixin|void)\s+\w+', content)
        deprecated_entities = re.findall(
            r'@(Deprecated|deprecated)\s*\(.*?\)\s*(class|enum|def|typedef|extension|mixin|void)\s+\w+', content)
        return len(entities) > 0 and len(entities) == len(deprecated_entities)


def generate_export_file():
    lib_folder = "../lib/"
    src_folder = lib_folder + "src"
    output_file = lib_folder + "clever_ads_solutions.dart"

    export_lines = []
    for root, dirs, files in os.walk(src_folder):
        if 'internal' in dirs:
            dirs.remove('internal')
        for file in files:
            if file.endswith(".dart"):
                full_path = os.path.join(root, file)
                if not is_entire_file_deprecated(full_path):
                    relative_path = os.path.relpath(full_path, start=lib_folder).replace("\\", "/")
                    export_line = f"export '{relative_path}';"
                    export_lines.append(export_line)

    export_lines.sort()

    with open(output_file, "w") as f:
        f.write("\n".join(export_lines))

    print(f"File '{output_file}' generated successfully!")


if __name__ == "__main__":
    generate_export_file()
